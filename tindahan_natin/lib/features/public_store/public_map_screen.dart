import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/store_map/store_shelf_tile.dart';

const double _boardExtent = 100000.0;
const double _boardOrigin = _boardExtent / 2;

class PublicMapScreen extends ConsumerWidget {
  final String slug;
  final String? highlightShelfId;

  const PublicMapScreen({super.key, required this.slug, this.highlightShelfId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(slug));

    return SizedBox.expand(
      child: storeInfoAsync.when(
        data: (info) {
          final List<Shelf> shelves = info['shelves'];

          return _CenteredPublicMap(
            shelves: shelves,
            highlightShelfId: highlightShelfId,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _CenteredPublicMap extends StatefulWidget {
  const _CenteredPublicMap({required this.shelves, required this.highlightShelfId});

  final List<Shelf> shelves;
  final String? highlightShelfId;

  @override
  State<_CenteredPublicMap> createState() => _CenteredPublicMapState();
}

class _CenteredPublicMapState extends State<_CenteredPublicMap> {
  final TransformationController _transformationController = TransformationController();
  bool _initialViewConfigured = false;

  void _configureInitialView(Size viewportSize) {
    if (_initialViewConfigured || viewportSize.isEmpty) {
      return;
    }

    _initialViewConfigured = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _transformationController.value = Matrix4.identity()
        ..setTranslationRaw(
          viewportSize.width / 2 - _boardOrigin,
          viewportSize.height / 2 - _boardOrigin,
          0,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _configureInitialView(constraints.biggest);

        return InteractiveViewer(
          clipBehavior: Clip.none,
          constrained: false,
          transformationController: _transformationController,
          boundaryMargin: EdgeInsets.all(_boardExtent * 2),
          minScale: 0.05,
          maxScale: 4.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: _boardExtent,
                height: _boardExtent,
                color: Colors.transparent,
              ),
              ...widget.shelves.map((shelf) {
                final isHighlighted = shelf.id == widget.highlightShelfId;
                return Positioned(
                  left: shelf.x + _boardOrigin,
                  top: shelf.y + _boardOrigin,
                  child: StoreShelfTile(
                    name: shelf.name,
                    isSelected: isHighlighted,
                    rotation: shelf.rotation,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}