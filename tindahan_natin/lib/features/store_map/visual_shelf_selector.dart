import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/store_map/store_shelf_tile.dart';

class VisualShelfSelector extends ConsumerStatefulWidget {
  final String storeId;
  final String? initialShelfId;

  const VisualShelfSelector({
    super.key,
    required this.storeId,
    this.initialShelfId,
  });

  @override
  ConsumerState<VisualShelfSelector> createState() => _VisualShelfSelectorState();
}

class _VisualShelfSelectorState extends ConsumerState<VisualShelfSelector> {
  final TransformationController _transformationController = TransformationController();
  final double _canvasSize = 100000.0;
  String? _selectedShelfId;
  bool _initialViewConfigured = false;
  bool _configuredForShelves = false;

  @override
  void initState() {
    super.initState();
    _selectedShelfId = widget.initialShelfId;
  }

  double get _canvasOrigin => _canvasSize / 2;

  void _configureInitialView(Size viewportSize, List<Shelf> shelves) {
    if (viewportSize.isEmpty) {
      return;
    }

    if (_initialViewConfigured) {
      if (shelves.isEmpty || _configuredForShelves) {
        return;
      }
    }

    if (shelves.isNotEmpty) {
      _initialViewConfigured = true;
      _configuredForShelves = true;
    } else {
      _initialViewConfigured = true;
      _configuredForShelves = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (shelves.isEmpty) {
        _transformationController.value = Matrix4.identity()
          ..setTranslationRaw(
            viewportSize.width / 2 - _canvasOrigin,
            viewportSize.height / 2 - _canvasOrigin,
            0,
          );
        return;
      }

      Shelf? targetShelf;
      if (_selectedShelfId != null && _selectedShelfId!.isNotEmpty) {
        try {
          targetShelf = shelves.firstWhere((s) => s.id == _selectedShelfId);
        } catch (_) {}
      }

      if (targetShelf != null) {
        _transformationController.value = Matrix4.identity()
          ..setTranslationRaw(
            viewportSize.width / 2 - (targetShelf.x + _canvasOrigin),
            viewportSize.height / 2 - (targetShelf.y + _canvasOrigin),
            0,
          );
      } else {
        double avgX = shelves.map((s) => s.x).reduce((a, b) => a + b) / shelves.length;
        double avgY = shelves.map((s) => s.y).reduce((a, b) => a + b) / shelves.length;

        _transformationController.value = Matrix4.identity()
          ..setTranslationRaw(
            viewportSize.width / 2 - (avgX + _canvasOrigin),
            viewportSize.height / 2 - (avgY + _canvasOrigin),
            0,
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shelvesAsync = ref.watch(shelvesProvider(widget.storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shelf'),
      ),
      body: shelvesAsync.when(
        data: (shelves) {
          return LayoutBuilder(
            builder: (context, constraints) {
              _configureInitialView(constraints.biggest, shelves);

              return InteractiveViewer(
                clipBehavior: Clip.none,
                constrained: false,
                transformationController: _transformationController,
                boundaryMargin: EdgeInsets.all(_canvasSize * 2),
                minScale: 0.1,
                maxScale: 2.0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context, '');
                      },
                      child: Container(
                        width: _canvasSize,
                        height: _canvasSize,
                        color: Colors.transparent,
                      ),
                    ),
                    ...shelves.map(
                      (shelf) => Positioned(
                        left: shelf.x + _canvasOrigin,
                        top: shelf.y + _canvasOrigin,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context, shelf.id);
                          },
                          child: StoreShelfTile(
                            name: shelf.name,
                            isSelected: _selectedShelfId == shelf.id,
                            rotation: shelf.rotation,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => AppErrorWidget(
          error: e,
          stackTrace: s,
          onRetry: () => ref.invalidate(shelvesProvider(widget.storeId)),
        ),
      ),
    );
  }
}
