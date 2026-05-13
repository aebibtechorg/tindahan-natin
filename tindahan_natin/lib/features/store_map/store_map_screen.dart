import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vm;

class StoreMapScreen extends ConsumerStatefulWidget {
  const StoreMapScreen({super.key});

  @override
  ConsumerState<StoreMapScreen> createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends ConsumerState<StoreMapScreen> {
  final TransformationController _transformationController = TransformationController();
  final GlobalKey _containerKey = GlobalKey();
  final Set<String> _selectedShelfIds = {};
  bool _multiSelectMode = false;
  bool _snapToGrid = true;
  double _gridSize = 50.0;

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) return const Center(child: Text('No store found'));
        final storeId = store.id;
        final shelvesAsync = ref.watch(shelvesProvider(storeId));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Store Map'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddShelfDialog(context, ref, storeId),
              ),
              IconButton(
                icon: Icon(_snapToGrid ? Icons.grid_on : Icons.grid_off),
                tooltip: _snapToGrid ? 'Grid: On' : 'Grid: Off',
                onPressed: () => setState(() => _snapToGrid = !_snapToGrid),
              ),
              IconButton(
                icon: Icon(_multiSelectMode ? Icons.check_box : Icons.check_box_outline_blank),
                tooltip: 'Multi-select',
                onPressed: () => setState(() {
                  _multiSelectMode = !_multiSelectMode;
                  if (!_multiSelectMode) _selectedShelfIds.clear();
                }),
              ),
              if (!_multiSelectMode && _selectedShelfIds.length == 1)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final shelves = await ref.read(shelvesProvider(storeId).future);
                    final shelf = shelves.firstWhere((s) => s.id == _selectedShelfIds.first);
                    _showEditShelfDialog(context, ref, shelf, storeId);
                  },
                ),
              if (!_multiSelectMode && _selectedShelfIds.length == 1)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final id = _selectedShelfIds.first;
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Delete Shelf?'),
                        content: const Text('Are you sure you want to delete this shelf?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref.read(mapServiceProvider).deleteShelf(id);
                      ref.invalidate(shelvesProvider(storeId));
                      setState(() => _selectedShelfIds.clear());
                    }
                  },
                ),
              if (_multiSelectMode && _selectedShelfIds.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Delete selected',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Delete Selected Shelves?'),
                        content: Text('Delete ${_selectedShelfIds.length} selected shelves?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      for (final id in _selectedShelfIds) {
                        await ref.read(mapServiceProvider).deleteShelf(id);
                      }
                      ref.invalidate(shelvesProvider(storeId));
                      setState(() => _selectedShelfIds.clear());
                    }
                  },
                ),
            ],
          ),
          body: shelvesAsync.when(
            data: (shelves) => InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(1000),
              minScale: 0.1,
              maxScale: 2.0,
              child: Stack(
                children: [
                  // Grid or Background
                  Container(
                    key: _containerKey,
                    width: 2000,
                    height: 2000,
                    color: Colors.grey[100],
                  ),
                  ...shelves.map((shelf) => DraggableShelf(
                        key: ValueKey(shelf.id),
                        shelf: shelf,
                        storeId: storeId,
                        transformationController: _transformationController,
                        containerKey: _containerKey,
                        selected: _selectedShelfIds.contains(shelf.id),
                        onSelect: (id) {
                          setState(() {
                            if (_multiSelectMode) {
                              if (_selectedShelfIds.contains(id)) {
                                _selectedShelfIds.remove(id);
                              } else {
                                _selectedShelfIds.add(id);
                              }
                            } else {
                              _selectedShelfIds.clear();
                              _selectedShelfIds.add(id);
                            }
                          });
                        },
                        onDoubleTap: () => _showEditShelfDialog(context, ref, shelf, storeId),
                        snapToGrid: _snapToGrid,
                        gridSize: _gridSize,
                      )),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error loading store: $e'))),
    );
  }

  void _showAddShelfDialog(BuildContext context, WidgetRef ref, String storeId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Shelf'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Shelf Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                // Place at center of container (taking current transform into account)
                double cx = 500.0, cy = 500.0;
                final containerContext = _containerKey.currentContext;
                if (containerContext != null) {
                  final rb = containerContext.findRenderObject() as RenderBox;
                  final centerLocal = rb.size.center(Offset.zero);
                  final centerGlobal = rb.localToGlobal(centerLocal);
                  final sceneCenter = _globalToScene(centerGlobal);
                  cx = sceneCenter.dx;
                  cy = sceneCenter.dy;
                }

                await ref.read(mapServiceProvider).createShelf({
                  'name': controller.text,
                  'storeId': storeId,
                  'x': _snapToGrid ? (cx / _gridSize).round() * _gridSize : cx,
                  'y': _snapToGrid ? (cy / _gridSize).round() * _gridSize : cy,
                });
                ref.invalidate(shelvesProvider(storeId));
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Offset _globalToScene(Offset global) {
    final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    final local = renderBox.globalToLocal(global);
    final m = _transformationController.value;
    final inverse = vm.Matrix4.fromList(m.storage.toList())..invert();
    final vec = vm.Vector3(local.dx, local.dy, 0);
    final scene = inverse.transform3(vec);
    return Offset(scene.x, scene.y);
  }

  void _showEditShelfDialog(BuildContext context, WidgetRef ref, Shelf shelf, String storeId) {
    final controller = TextEditingController(text: shelf.name);
    double rotation = shelf.rotation;

    showDialog(
      context: context,
      builder: (context) {
        final productsAsync = ref.watch(productsProvider(storeId));
        final productLocationsAsync = ref.watch(productLocationsProvider(storeId));

        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Shelf'),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Shelf Name'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Rotation'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Slider(
                            value: rotation,
                            min: 0,
                            max: 360,
                            divisions: 36,
                            label: '${rotation.round()}°',
                            onChanged: (v) => setDialogState(() => rotation = v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${rotation.round()}°'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Product Locations', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () async {
                            // open product picker
                            final products = productsAsync.maybeWhen(data: (p) => p, orElse: () => null);
                            if (products == null || products.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No products available')));
                              return;
                            }

                            final selected = await showDialog<Map<String, dynamic>?>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text('Select Product'),
                                children: products.map((prod) => SimpleDialogOption(
                                      onPressed: () => Navigator.pop(ctx, {'id': prod.id, 'name': prod.name}),
                                      child: Text(prod.name),
                                    )).toList(),
                              ),
                            );

                            if (selected != null) {
                              await ref.read(mapServiceProvider).createProductLocation({
                                'productId': selected['id'],
                                'shelfId': shelf.id,
                                'position': 'default',
                              });
                              ref.invalidate(productLocationsProvider(storeId));
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    productLocationsAsync.when(
                      data: (locations) {
                        final shelfLocations = locations.where((l) => l.shelfId == shelf.id).toList();
                        if (shelfLocations.isEmpty) return const Text('No product locations.');
                        return Column(
                          children: shelfLocations.map((loc) {
                            String productName = loc.productId;
                            final productsList = productsAsync.asData?.value;
                            if (productsList != null) {
                              final matches = productsList.where((p) => p.id == loc.productId);
                              if (matches.isNotEmpty) productName = matches.first.name;
                            }
                            return ListTile(
                              title: Text(productName),
                              subtitle: Text('Position: ${loc.position}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await ref.read(mapServiceProvider).deleteProductLocation(loc.id);
                                  ref.invalidate(productLocationsProvider(storeId));
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Text('Error loading product locations: $e'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    await ref.read(mapServiceProvider).updateShelf(shelf.id, {
                      'name': controller.text,
                      'x': shelf.x,
                      'y': shelf.y,
                      'rotation': rotation,
                    });
                    ref.invalidate(shelvesProvider(storeId));
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }
}
class DraggableShelf extends ConsumerStatefulWidget {
  final Shelf shelf;
  final String storeId;
  final TransformationController transformationController;
  final GlobalKey containerKey;
  final bool selected;
  final void Function(String) onSelect;
  final VoidCallback? onDoubleTap;
  final bool snapToGrid;
  final double gridSize;

  const DraggableShelf({
    super.key,
    required this.shelf,
    required this.storeId,
    required this.transformationController,
    required this.containerKey,
    required this.selected,
    required this.onSelect,
    this.onDoubleTap,
    required this.snapToGrid,
    required this.gridSize,
  });

  @override
  ConsumerState<DraggableShelf> createState() => _DraggableShelfState();
}

class _DraggableShelfState extends ConsumerState<DraggableShelf> {
  late double x;
  late double y;
  late double rotation;
  Offset? _dragOffset;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    x = widget.shelf.x;
    y = widget.shelf.y;
    rotation = widget.shelf.rotation;
  }

  @override
  void didUpdateWidget(covariant DraggableShelf oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync if upstream shelf changed
    if (widget.shelf.x != x || widget.shelf.y != y) {
      x = widget.shelf.x;
      y = widget.shelf.y;
    }
    if (widget.shelf.rotation != rotation) {
      rotation = widget.shelf.rotation;
    }
  }

  Offset _globalToScene(Offset global) {
    final renderBox = widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    final local = renderBox.globalToLocal(global);
    final m = widget.transformationController.value;
    final inverse = vm.Matrix4.fromList(m.storage.toList())..invert();
    final vec = vm.Vector3(local.dx, local.dy, 0);
    final scene = inverse.transform3(vec);
    return Offset(scene.x, scene.y);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () => widget.onSelect(widget.shelf.id),
        onDoubleTap: widget.onDoubleTap,
        onPanStart: (details) {
          widget.onSelect(widget.shelf.id);
          final scenePoint = _globalToScene(details.globalPosition);
          _dragOffset = scenePoint - Offset(x, y);
          setState(() => _dragging = true);
        },
        onPanUpdate: (details) {
          final scenePoint = _globalToScene(details.globalPosition);
          final newX = scenePoint.dx - (_dragOffset?.dx ?? 0);
          final newY = scenePoint.dy - (_dragOffset?.dy ?? 0);
          setState(() {
            x = newX.clamp(0.0, 2000.0 - 50.0).toDouble();
            y = newY.clamp(0.0, 2000.0 - 50.0).toDouble();
          });
        },
        onPanEnd: (details) async {
          setState(() => _dragging = false);
          if (widget.snapToGrid) {
            x = (x / widget.gridSize).round() * widget.gridSize;
            y = (y / widget.gridSize).round() * widget.gridSize;
          }
          await ref.read(mapServiceProvider).updateShelf(widget.shelf.id, {
            'name': widget.shelf.name,
            'x': x,
            'y': y,
            'rotation': rotation,
          });
          ref.invalidate(shelvesProvider(widget.storeId));
        },
        child: _ShelfWidget(name: widget.shelf.name, isDragging: _dragging, isSelected: widget.selected, rotation: rotation),
      ),
    );
  }
}

class _ShelfWidget extends StatelessWidget {
  final String name;
  final bool isDragging;
  final bool isSelected;
  final double rotation;

  const _ShelfWidget({required this.name, this.isDragging = false, this.isSelected = false, this.rotation = 0.0});

  @override
  Widget build(BuildContext context) {
    final rotated = Transform.rotate(
      angle: rotation * math.pi / 180.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDragging ? Colors.blue.withOpacity(0.6) : Colors.blue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          border: isSelected ? Border.all(color: Colors.yellowAccent, width: 3) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    return rotated;
  }
}