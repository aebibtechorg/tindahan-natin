import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/network/connectivity_provider.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/core/widgets/ad_widgets/interstitial_ad_provider.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/shared/utils/snackbar_utils.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/products/product.dart';
import 'package:tindahan_natin/features/store_map/store_shelf_tile.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class StoreMapScreen extends ConsumerStatefulWidget {
  const StoreMapScreen({super.key});

  @override
  ConsumerState<StoreMapScreen> createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends ConsumerState<StoreMapScreen> {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _containerKey = GlobalKey();
  final Set<String> _selectedShelfIds = {};
  bool _multiSelectMode = false;
  bool _snapToGrid = true;
  final double _gridSize = 50.0;
  final double _canvasSize = 100000.0;
  final Map<String, Shelf> _optimisticShelves = {};
  final Set<String> _optimisticRemovedIds = {};
  final Map<String, Shelf> _bulkMoveStartShelves = {};
  bool _initialViewConfigured = false;
  Size _viewportSize = Size.zero;
  bool _showTutorial = true;

  @override
  void initState() {
    super.initState();
    _showTutorial = !ref.read(localStorageProvider).isMapTutorialDismissed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(isOnlineProvider)) {
        ref.read(interstitialAdProvider).showAdIfReady();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  double get _canvasOrigin => _canvasSize / 2;

  double _snapCoordinate(double value) {
    if (!_snapToGrid) {
      return value;
    }

    return (value / _gridSize).round() * _gridSize;
  }

  void _removeLocalShelfState(Iterable<String> shelfIds) {
    for (final shelfId in shelfIds) {
      _optimisticShelves.remove(shelfId);
      _optimisticRemovedIds.remove(shelfId);
      _bulkMoveStartShelves.remove(shelfId);
      _selectedShelfIds.remove(shelfId);
    }
  }

  Offset _viewportCenterScene() {
    if (_viewportSize.isEmpty) {
      return Offset.zero;
    }

    final viewportCenter = _viewportSize.center(Offset.zero);
    final m = _transformationController.value;
    final inverse = vm.Matrix4.fromList(m.storage.toList())..invert();
    final vec = vm.Vector3(viewportCenter.dx, viewportCenter.dy, 0);
    final scene = inverse.transform3(vec);
    return Offset(scene.x - _canvasOrigin, scene.y - _canvasOrigin);
  }

  Future<void> _addShelfAtVisibleCenter(
    BuildContext context,
    String storeId,
  ) async {
    if (_viewportSize.isEmpty) {
      return;
    }

    const shelfName = 'New Shelf';
    final scenePosition = _viewportCenterScene();
    final snapX = _snapCoordinate(scenePosition.dx);
    final snapY = _snapCoordinate(scenePosition.dy);
    final tempId = 'tmp-${DateTime.now().microsecondsSinceEpoch}';
    final tempShelf = Shelf(
      id: tempId,
      name: shelfName,
      storeId: storeId,
      x: snapX,
      y: snapY,
      rotation: 0.0,
    );

    setState(() {
      _optimisticShelves[tempId] = tempShelf;
      _selectedShelfIds
        ..clear()
        ..add(tempId);
    });

    try {
      final created = await ref.read(mapServiceProvider).createShelf({
        'name': shelfName,
        'storeId': storeId,
        'x': snapX,
        'y': snapY,
      });
      ref.invalidate(shelvesProvider(storeId));

      if (!mounted) {
        return;
      }

      setState(() {
        _optimisticShelves.remove(tempId);
        _optimisticShelves[created.id] = created;
        _selectedShelfIds
          ..clear()
          ..add(created.id);
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _optimisticShelves.remove(tempId);
        _selectedShelfIds.remove(tempId);
      });

      if (context.mounted) {
        SnackBarUtils.showError(context, e);
      }
    }
  }

  void _configureInitialView(Size viewportSize) {
    if (_initialViewConfigured || viewportSize.isEmpty) {
      return;
    }

    _initialViewConfigured = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _transformationController.value = vm.Matrix4.identity()
        ..setTranslationRaw(
          viewportSize.width / 2 - _canvasOrigin,
          viewportSize.height / 2 - _canvasOrigin,
          0,
        );
    });
  }

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
                tooltip: 'Add shelf',
                onPressed: () => _addShelfAtVisibleCenter(context, storeId),
              ),
              IconButton(
                icon: Icon(_snapToGrid ? Icons.grid_on : Icons.grid_off),
                tooltip: _snapToGrid ? 'Grid: On' : 'Grid: Off',
                onPressed: () => setState(() => _snapToGrid = !_snapToGrid),
              ),
              IconButton(
                icon: Icon(
                  _multiSelectMode
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
                tooltip: 'Multi-select',
                onPressed: () => setState(() {
                  _multiSelectMode = !_multiSelectMode;
                  if (!_multiSelectMode) _selectedShelfIds.clear();
                }),
              ),
              if (!_multiSelectMode && _selectedShelfIds.length == 1)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final shelfId = _selectedShelfIds.first;
                    final shelves =
                        ref.read(shelvesProvider(storeId)).value ?? [];

                    Shelf? targetShelf = _optimisticShelves[shelfId];
                    if (targetShelf == null) {
                      try {
                        targetShelf = shelves.firstWhere(
                          (s) => s.id == shelfId,
                        );
                      } catch (_) {}
                    }

                    if (targetShelf != null) {
                      _showEditShelfDialog(context, ref, targetShelf, storeId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Shelf not found. Please try again.'),
                        ),
                      );
                    }
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
                        content: const Text(
                          'Are you sure you want to delete this shelf?',
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(c, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      setState(() {
                        _optimisticRemovedIds.add(id);
                        _selectedShelfIds.clear();
                      });
                      try {
                        await ref.read(mapServiceProvider).deleteShelf(id, storeId: storeId);
                        ref.invalidate(shelvesProvider(storeId));
                        setState(() => _removeLocalShelfState([id]));
                        if (context.mounted) SnackBarUtils.showSuccess(context, 'Shelf deleted');
                      } catch (e) {
                        setState(() => _optimisticRemovedIds.remove(id));
                        if (context.mounted) {
                          SnackBarUtils.showError(context, e);
                        }
                      }
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
                        content: Text(
                          'Delete ${_selectedShelfIds.length} selected shelves?',
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(c, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final idsToDelete = List<String>.from(_selectedShelfIds);
                      setState(() {
                        _optimisticRemovedIds.addAll(idsToDelete);
                        _selectedShelfIds.clear();
                      });
                      for (final id in idsToDelete) {
                        try {
                          await ref.read(mapServiceProvider).deleteShelf(id, storeId: storeId);
                        } catch (e) {
                          setState(() => _optimisticRemovedIds.remove(id));
                          if (context.mounted) {
                            SnackBarUtils.showError(context, 'Delete failed for $id');
                          }
                        }
                      }
                      setState(() => _removeLocalShelfState(idsToDelete));
                      ref.invalidate(shelvesProvider(storeId));
                      if (context.mounted) SnackBarUtils.showSuccess(context, '${idsToDelete.length} shelves deleted');
                    }
                  },
                ),
            ],
          ),
          body: shelvesAsync.when(
            data: (shelves) {
              final serverById = {for (var shelf in shelves) shelf.id: shelf};
              final displayedShelves = <Shelf>[];

              for (final shelf in shelves) {
                if (_optimisticRemovedIds.contains(shelf.id)) {
                  continue;
                }
                displayedShelves.add(_optimisticShelves[shelf.id] ?? shelf);
              }

              for (final shelf in _optimisticShelves.values) {
                if (!serverById.containsKey(shelf.id) &&
                    !_optimisticRemovedIds.contains(shelf.id)) {
                  displayedShelves.add(shelf);
                }
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  _viewportSize = constraints.biggest;
                  _configureInitialView(constraints.biggest);

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: InteractiveViewer(
                          clipBehavior: Clip.none,
                          constrained: false,
                          transformationController: _transformationController,
                          boundaryMargin: EdgeInsets.all(_canvasSize * 2),
                          minScale: 0.05,
                          maxScale: 4.0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (_selectedShelfIds.isNotEmpty) {
                                    setState(_selectedShelfIds.clear);
                                  }
                                },
                                child: Container(
                                  key: _containerKey,
                                  width: _canvasSize,
                                  height: _canvasSize,
                                  color: Colors.transparent,
                                ),
                              ),
                              ...displayedShelves.map(
                                (shelf) => DraggableShelf(
                                  key: ValueKey(shelf.id),
                                  shelf: shelf,
                                  storeId: storeId,
                                  canvasOrigin: _canvasOrigin,
                                  transformationController: _transformationController,
                                  containerKey: _containerKey,
                                  selected: _selectedShelfIds.contains(shelf.id),
                                  selectedShelfIds: _selectedShelfIds,
                                  onSelect: (id) {
                                    setState(() {
                                      if (_multiSelectMode) {
                                        if (_selectedShelfIds.contains(id)) {
                                          _selectedShelfIds.remove(id);
                                        } else {
                                          _selectedShelfIds.add(id);
                                        }
                                      } else {
                                        _selectedShelfIds
                                          ..clear()
                                          ..add(id);
                                      }
                                    });
                                  },
                                  onDoubleTap: () => _showEditShelfDialog(
                                    context,
                                    ref,
                                    shelf,
                                    storeId,
                                  ),
                                  snapToGrid: _snapToGrid,
                                  gridSize: _gridSize,
                                  onOptimisticUpdate: (updated) => setState(
                                    () => _optimisticShelves[updated.id] = updated,
                                  ),
                                  onBulkMoveStart: (ids) =>
                                      _startBulkShelfMove(displayedShelves, ids),
                                  onBulkOptimisticUpdate: (ids, delta) =>
                                      _applyBulkShelfMove(
                                        displayedShelves,
                                        ids,
                                        delta,
                                      ),
                                  onBulkCommit: (ids) =>
                                      _commitBulkShelfMove(displayedShelves, ids, storeId),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showTutorial)
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.help_outline,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'How to use the Map',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _showTutorial = false;
                                          });
                                          ref.read(localStorageProvider).setMapTutorialDismissed(true);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTutorialItem(
                                    context,
                                    icon: Icons.add,
                                    text: 'Tap "+" in the AppBar to add a new shelf.',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTutorialItem(
                                    context,
                                    icon: Icons.back_hand,
                                    text: 'Drag shelves to place them. Pinch to zoom/pan.',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTutorialItem(
                                    context,
                                    icon: Icons.touch_app,
                                    text: 'Double-tap a shelf to rename it or link products.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => AppErrorWidget(
              error: e,
              stackTrace: s,
              onRetry: () => ref.invalidate(shelvesProvider(storeId)),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(
        body: AppErrorWidget(
          error: e,
          stackTrace: s,
          onRetry: () => ref.invalidate(myStoreProvider),
        ),
      ),
    );
  }

  void _applyBulkShelfMove(
    List<Shelf> shelves,
    Set<String> shelfIds,
    Offset delta,
  ) {
    setState(() {
      for (final shelf in shelves) {
        if (!shelfIds.contains(shelf.id)) continue;
        final base =
            _bulkMoveStartShelves[shelf.id] ??
            _optimisticShelves[shelf.id] ??
            shelf;
        final updatedX = base.x + delta.dx;
        final updatedY = base.y + delta.dy;
        _optimisticShelves[shelf.id] = base.copyWith(x: updatedX, y: updatedY);
      }
    });
  }

  void _startBulkShelfMove(List<Shelf> shelves, Set<String> shelfIds) {
    _bulkMoveStartShelves
      ..clear()
      ..addEntries(
        shelves
            .where((shelf) => shelfIds.contains(shelf.id))
            .map(
              (shelf) =>
                  MapEntry(shelf.id, _optimisticShelves[shelf.id] ?? shelf),
            ),
      );
  }

  Future<void> _commitBulkShelfMove(
    List<Shelf> shelves,
    Set<String> shelfIds,
    String storeId,
  ) async {
    final snapshot = Map<String, Shelf>.from(_bulkMoveStartShelves);

    try {
      for (final shelfId in shelfIds) {
        final updatedShelf =
            _optimisticShelves[shelfId] ??
            shelves.firstWhere((s) => s.id == shelfId);
        if (updatedShelf.id.startsWith('tmp-')) {
          continue;
        }
        await ref.read(mapServiceProvider).updateShelf(shelfId, {
          'name': updatedShelf.name,
          'x': updatedShelf.x,
          'y': updatedShelf.y,
          'rotation': updatedShelf.rotation,
        }, storeId: storeId);
      }
      ref.invalidate(shelvesProvider(storeId));
    } catch (e) {
      setState(() {
        for (final entry in snapshot.entries) {
          _optimisticShelves[entry.key] = entry.value;
        }
      });
      rethrow;
    } finally {
      _bulkMoveStartShelves.clear();
    }
  }

  void _showEditShelfDialog(
    BuildContext context,
    WidgetRef ref,
    Shelf shelf,
    String storeId,
  ) {
    final controller = TextEditingController(text: shelf.name);
    double rotation = shelf.rotation;

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, dialogRef, _) {
          final productsAsync = dialogRef.watch(productsProvider(storeId));

          return StatefulBuilder(
            builder: (context, setDialogState) {
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
                          decoration: const InputDecoration(
                            hintText: 'Shelf Name',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('Rotation'),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Slider(
                                value: rotation.clamp(-360.0, 360.0),
                                min: -360,
                                max: 360,
                                divisions: 72,
                                label: '${rotation.round()}°',
                                onChanged: (v) =>
                                    setDialogState(() => rotation = v),
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
                            const Text(
                              'Products on Shelf',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            productsAsync.when(
                              data: (productsList) {
                                final shelvesList = dialogRef.watch(shelvesProvider(storeId)).asData?.value ?? [];
                                return TextButton.icon(
                                  onPressed: () async {
                                    final selectedProduct = await showDialog<Product>(
                                      context: context,
                                      builder: (ctx) => _AddProductToShelfDialog(
                                        storeId: storeId,
                                        shelfId: shelf.id,
                                        allProducts: productsList,
                                        shelves: shelvesList,
                                      ),
                                    );

                                    if (selectedProduct != null) {
                                      final updatedData = {
                                        ...selectedProduct.toJson(),
                                        'shelfId': shelf.id,
                                      };
                                      try {
                                        await ref
                                            .read(productsProvider(storeId).notifier)
                                            .updateProduct(selectedProduct.id, updatedData);
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Add product to shelf failed: $e')),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add'),
                                );
                              },
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        productsAsync.when(
                          data: (productsList) {
                            final assigned = productsList.where((p) => p.shelfId == shelf.id).toList();
                            if (assigned.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('No products on this shelf.'),
                              );
                            }
                            return Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: assigned.length,
                                itemBuilder: (context, index) {
                                  final product = assigned[index];
                                  return ListTile(
                                    title: Text(product.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        final updatedData = {
                                          ...product.toJson(),
                                          'shelfId': null,
                                        };
                                        try {
                                          await ref
                                              .read(productsProvider(storeId).notifier)
                                              .updateProduct(product.id, updatedData);
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Remove product from shelf failed: $e')),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text('Error loading products: $e'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty) {
                        final updatedShelf = shelf.copyWith(
                          name: controller.text,
                          rotation: rotation,
                        );
                        setState(
                          () => _optimisticShelves[shelf.id] = updatedShelf,
                        );
                        if (context.mounted) Navigator.pop(context);
                        try {
                          await ref
                              .read(mapServiceProvider)
                              .updateShelf(shelf.id, {
                                'name': controller.text,
                                'x': updatedShelf.x,
                                'y': updatedShelf.y,
                                'rotation': rotation,
                              }, storeId: storeId);
                          ref.invalidate(shelvesProvider(storeId));
                          setState(
                            () => _optimisticShelves[shelf.id] = updatedShelf,
                          );
                          if (context.mounted) SnackBarUtils.showSuccess(context, 'Shelf updated');
                        } catch (e) {
                          setState(() => _optimisticShelves.remove(shelf.id));
                          if (context.mounted) {
                            SnackBarUtils.showError(context, e);
                          }
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTutorialItem(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  @visibleForTesting
  void showEditShelfDialogPublicForTesting(Shelf shelf) {
    _showEditShelfDialog(context, ref, shelf, shelf.storeId);
  }
}

class _AddProductToShelfDialog extends StatefulWidget {
  final String storeId;
  final String shelfId;
  final List<Product> allProducts;
  final List<Shelf> shelves;

  const _AddProductToShelfDialog({
    required this.storeId,
    required this.shelfId,
    required this.allProducts,
    required this.shelves,
  });

  @override
  State<_AddProductToShelfDialog> createState() => _AddProductToShelfDialogState();
}

class _AddProductToShelfDialogState extends State<_AddProductToShelfDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = widget.allProducts.where((product) {
      if (_searchQuery.isEmpty) return true;
      return product.name.toLowerCase().contains(_searchQuery) ||
          (product.description?.toLowerCase().contains(_searchQuery) ?? false) ||
          (product.barcode?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();

    return AlertDialog(
      title: const Text('Add Product to Shelf'),
      content: SizedBox(
        width: 400,
        height: 450,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : Scrollbar(
                      child: ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          
                          // Check if assigned to any shelf using product.shelfId
                          final isAssigned = product.shelfId != null;
                          String? shelfName;
                          if (isAssigned) {
                            Shelf? otherShelf;
                            for (final s in widget.shelves) {
                              if (s.id == product.shelfId) {
                                otherShelf = s;
                                break;
                              }
                            }
                            shelfName = otherShelf?.name ?? 'Other Shelf';
                          }

                          return ListTile(
                            title: Text(
                              product.name,
                              style: isAssigned
                                  ? TextStyle(color: Theme.of(context).disabledColor)
                                  : null,
                            ),
                            subtitle: isAssigned
                                ? Text(
                                    'Already on: $shelfName',
                                    style: TextStyle(color: Theme.of(context).disabledColor),
                                  )
                                : null,
                            enabled: !isAssigned,
                            onTap: () {
                              Navigator.pop(context, product);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class DraggableShelf extends ConsumerStatefulWidget {
  final Shelf shelf;
  final String storeId;
  final double canvasOrigin;
  final TransformationController transformationController;
  final GlobalKey containerKey;
  final bool selected;
  final Set<String> selectedShelfIds;
  final void Function(String) onSelect;
  final VoidCallback? onDoubleTap;
  final bool snapToGrid;
  final double gridSize;
  final void Function(Shelf)? onOptimisticUpdate;
  final void Function(Set<String>)? onBulkMoveStart;
  final void Function(Set<String>, Offset)? onBulkOptimisticUpdate;
  final Future<void> Function(Set<String>)? onBulkCommit;

  const DraggableShelf({
    super.key,
    required this.shelf,
    required this.storeId,
    required this.canvasOrigin,
    required this.transformationController,
    required this.containerKey,
    required this.selected,
    required this.selectedShelfIds,
    required this.onSelect,
    this.onDoubleTap,
    this.onOptimisticUpdate,
    this.onBulkMoveStart,
    this.onBulkOptimisticUpdate,
    this.onBulkCommit,
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
  late double _dragStartX;
  late double _dragStartY;
  late double _startRotation;
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
    if (widget.shelf.x != x || widget.shelf.y != y) {
      x = widget.shelf.x;
      y = widget.shelf.y;
    }
    if (widget.shelf.rotation != rotation) {
      rotation = widget.shelf.rotation;
    }
  }

  Offset _globalToScene(Offset global) {
    final renderBox =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    final local = renderBox.globalToLocal(global);
    final m = widget.transformationController.value;
    final inverse = vm.Matrix4.fromList(m.storage.toList())..invert();
    final vec = vm.Vector3(local.dx, local.dy, 0);
    final scene = inverse.transform3(vec);
    return Offset(scene.x - widget.canvasOrigin, scene.y - widget.canvasOrigin);
  }

  bool get _isBulkMoveTarget =>
      widget.selectedShelfIds.length > 1 &&
      widget.selectedShelfIds.contains(widget.shelf.id);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x + widget.canvasOrigin,
      top: y + widget.canvasOrigin,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onSelect(widget.shelf.id),
        onDoubleTap: widget.onDoubleTap,
        onScaleStart: (details) {
          widget.onSelect(widget.shelf.id);
          final scenePoint = _globalToScene(details.focalPoint);
          _dragOffset = scenePoint - Offset(x, y);
          _dragStartX = x;
          _dragStartY = y;
          _startRotation = rotation;
          if (_isBulkMoveTarget) {
            widget.onBulkMoveStart?.call(widget.selectedShelfIds);
          }
          setState(() => _dragging = true);
        },
        onScaleUpdate: (details) {
          final scenePoint = _globalToScene(details.focalPoint);
          final newX = scenePoint.dx - (_dragOffset?.dx ?? 0);
          final newY = scenePoint.dy - (_dragOffset?.dy ?? 0);
          double newRotation = rotation;
          if (details.pointerCount >= 2) {
            newRotation = _startRotation + (details.rotation * (180 / math.pi));
          }
          setState(() {
            x = newX;
            y = newY;
            if (details.pointerCount >= 2) {
              rotation = newRotation % 360.0;
            }
          });
          if (_isBulkMoveTarget) {
            widget.onBulkOptimisticUpdate?.call(
              widget.selectedShelfIds,
              Offset(x - _dragStartX, y - _dragStartY),
            );
          }
        },
        onScaleEnd: (details) async {
          setState(() => _dragging = false);
          final prevX = widget.shelf.x;
          final prevY = widget.shelf.y;
          final prevRotation = widget.shelf.rotation;
          if (widget.snapToGrid) {
            x = (x / widget.gridSize).round() * widget.gridSize;
            y = (y / widget.gridSize).round() * widget.gridSize;
          }

          final updatedShelf = widget.shelf.copyWith(
            x: x,
            y: y,
            rotation: rotation,
          );
          widget.onOptimisticUpdate?.call(updatedShelf);

          if (_isBulkMoveTarget) {
            widget.onBulkOptimisticUpdate?.call(
              widget.selectedShelfIds,
              Offset(x - _dragStartX, y - _dragStartY),
            );
            try {
              await widget.onBulkCommit?.call(widget.selectedShelfIds);
            } catch (e) {
              if (context.mounted) {
                SnackBarUtils.showError(context, e);
              }
            }
            return;
          }

          if (widget.shelf.id.startsWith('tmp-')) return;

          try {
            await ref.read(mapServiceProvider).updateShelf(widget.shelf.id, {
              'name': widget.shelf.name,
              'x': x,
              'y': y,
              'rotation': rotation,
            }, storeId: widget.storeId);
            ref.invalidate(shelvesProvider(widget.storeId));
            widget.onOptimisticUpdate?.call(updatedShelf);
          } catch (e) {
            setState(() {
              x = prevX;
              y = prevY;
              rotation = prevRotation;
            });
            widget.onOptimisticUpdate?.call(
              widget.shelf.copyWith(x: prevX, y: prevY, rotation: prevRotation),
            );
            if (context.mounted) {
              SnackBarUtils.showError(context, e);
            }
          }
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 96, minHeight: 48),
          child: StoreShelfTile(
            name: widget.shelf.name,
            isDragging: _dragging,
            isSelected: widget.selected,
            rotation: rotation,
          ),
        ),
      ),
    );
  }
}
