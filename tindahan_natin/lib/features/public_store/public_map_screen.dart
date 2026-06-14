import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
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
            slug: slug,
            shelves: shelves,
            highlightShelfId: highlightShelfId,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => AppErrorWidget(
          error: e,
          stackTrace: s,
          onRetry: () => ref.invalidate(publicStoreInfoProvider(slug)),
        ),
      ),
    );
  }
}

class _CenteredPublicMap extends ConsumerStatefulWidget {
  const _CenteredPublicMap({
    required this.slug,
    required this.shelves,
    required this.highlightShelfId,
  });

  final String slug;
  final List<Shelf> shelves;
  final String? highlightShelfId;

  @override
  ConsumerState<_CenteredPublicMap> createState() => _CenteredPublicMapState();
}

class _CenteredPublicMapState extends ConsumerState<_CenteredPublicMap> {
  final TransformationController _transformationController = TransformationController();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _localHighlightShelfId;
  bool _initialViewConfigured = false;
  Size _viewportSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _localHighlightShelfId = widget.highlightShelfId;
  }

  @override
  void didUpdateWidget(covariant _CenteredPublicMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightShelfId != oldWidget.highlightShelfId) {
      setState(() {
        _localHighlightShelfId = widget.highlightShelfId;
      });
      if (_localHighlightShelfId != null) {
        _centerOnShelf(_localHighlightShelfId!);
      }
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _centerOnShelf(String shelfId) {
    Shelf? target;
    for (final s in widget.shelves) {
      if (s.id == shelfId) {
        target = s;
        break;
      }
    }
    if (target != null && !_viewportSize.isEmpty) {
      final targetMatrix = Matrix4.identity()
        ..setTranslationRaw(
          _viewportSize.width / 2 - (_boardOrigin + target.x),
          _viewportSize.height / 2 - (_boardOrigin + target.y),
          0,
        );
      setState(() {
        _transformationController.value = targetMatrix;
      });
    }
  }

  void _configureInitialView(Size viewportSize) {
    _viewportSize = viewportSize;
    if (_initialViewConfigured || viewportSize.isEmpty) {
      return;
    }

    _initialViewConfigured = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (_localHighlightShelfId != null) {
        _centerOnShelf(_localHighlightShelfId!);
      } else {
        _transformationController.value = Matrix4.identity()
          ..setTranslationRaw(
            viewportSize.width / 2 - _boardOrigin,
            viewportSize.height / 2 - _boardOrigin,
            0,
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = _query.isEmpty
        ? null
        : ref.watch(publicProductSearchProvider(widget.slug, _query));

    return LayoutBuilder(
      builder: (context, constraints) {
        _configureInitialView(constraints.biggest);

        return Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
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
                      final isHighlighted = shelf.id == _localHighlightShelfId;
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
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products to find their shelf...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _query = '';
                                    _localHighlightShelfId = null;
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _query = val;
                        });
                      },
                    ),
                  ),
                  if (searchAsync != null) ...[
                    const SizedBox(height: 4),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: searchAsync.when(
                        data: (products) {
                          if (products.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No products found.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                          return ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: products.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final hasShelf = product.shelfId != null;
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(
                                    hasShelf
                                        ? 'Shelf: ${product.shelfName ?? 'Unnamed Shelf'}'
                                        : 'No shelf assigned',
                                    style: TextStyle(
                                      color: hasShelf ? Colors.green : Colors.grey,
                                      fontWeight: hasShelf ? FontWeight.w500 : FontWeight.normal,
                                    ),
                                  ),
                                  trailing: Text(
                                    '₱${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (product.shelfId != null) {
                                      setState(() {
                                        _localHighlightShelfId = product.shelfId;
                                        _query = '';
                                        _searchController.clear();
                                      });
                                      _centerOnShelf(product.shelfId!);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Located ${product.name} on ${product.shelfName ?? 'shelf'}',
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product.name} is not assigned to any shelf.',
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: $err',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}