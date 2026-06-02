import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';

class PublicStoreScreen extends ConsumerStatefulWidget {
  final String slug;
  final ValueChanged<String?>? onOpenMap;

  const PublicStoreScreen({super.key, required this.slug, this.onOpenMap});

  @override
  ConsumerState<PublicStoreScreen> createState() => _PublicStoreScreenState();
}

class _PublicStoreScreenState extends ConsumerState<PublicStoreScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _query = value.trim();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(publicProductSearchProvider(widget.slug, _query));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for products (e.g. Tomi)',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                        setState(() {
                          _query = '';
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _query = _searchController.text;
                        });
                      },
                    ),
            ),
            onChanged: _onSearchChanged,
            onSubmitted: (val) {
              _debounce?.cancel();
              setState(() {
                _query = val;
              });
            },
          ),
        ),
        Expanded(
          child: searchAsync.when(
            data: (products) {
              if (products.isEmpty) return const Center(child: Text('No products found.'));

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  const adInterval = 10;
                  final itemCount = products.length + (products.length / adInterval).floor();

                  if (isWide) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 80,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        final isAd = (index + 1) % (adInterval + 1) == 0;
                        if (isAd) {
                          return const Card(
                            margin: EdgeInsets.zero,
                            child: Center(child: InlineAdWidget()),
                          );
                        }

                        final productIndex = index - (index / (adInterval + 1)).floor();
                        final product = products[productIndex];
                        return Card(
                          margin: EdgeInsets.zero,
                          child: _PublicProductTile(
                            product: product,
                            onOpenMap: widget.onOpenMap,
                          ),
                        );
                      },
                    );
                  }

                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final isAd = (index + 1) % (adInterval + 1) == 0;
                      if (isAd) {
                        return const SizedBox(
                          width: double.infinity,
                          child: InlineAdWidget(),
                        );
                      }

                      final productIndex = index - (index / (adInterval + 1)).floor();
                      final product = products[productIndex];

                      return _PublicProductTile(
                        product: product,
                        onOpenMap: widget.onOpenMap,
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => AppErrorWidget(
              error: e,
              stackTrace: s,
              compact: true,
              onRetry: () => ref.invalidate(publicProductSearchProvider),
            ),
          ),
        ),
      ],
    );
  }
}

class _PublicProductTile extends ConsumerWidget {
  final PublicProduct product;
  final ValueChanged<String?>? onOpenMap;

  const _PublicProductTile({required this.product, this.onOpenMap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: product.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl!.contains('api')
                      ? '${ref.read(apiBaseUrlProvider)}${product.imageUrl}'
                      : product.imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.shopping_bag),
      ),
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        product.shelfName == null
            ? '₱${product.price} • Shelf unavailable'
            : '₱${product.price} • Shelf: ${product.shelfName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: product.shelfId != null
          ? SizedBox(
              width: 48,
              child: IconButton(
                onPressed: () => onOpenMap?.call(product.shelfId),
                tooltip: 'Find on map',
                icon: const Icon(Icons.place_outlined),
              ),
            )
          : null,
      onTap: () => onOpenMap?.call(product.shelfId),
    );
  }
}
