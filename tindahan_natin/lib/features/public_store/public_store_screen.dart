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
              hintText: 'Search for products',
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
                    final slivers = <Widget>[];
                    for (int i = 0; i < products.length; i += adInterval) {
                      final chunk = products.sublist(
                        i,
                        i + adInterval > products.length ? products.length : i + adInterval,
                      );
                      slivers.add(
                        SliverPadding(
                          padding: const EdgeInsets.all(8),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              mainAxisExtent: 80,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = chunk[index];
                                return Card(
                                  margin: EdgeInsets.zero,
                                  child: _PublicProductTile(
                                    product: product,
                                    onOpenMap: widget.onOpenMap,
                                  ),
                                );
                              },
                              childCount: chunk.length,
                            ),
                          ),
                        ),
                      );
                      if (i + adInterval < products.length) {
                        slivers.add(
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: InlineAdWidget(),
                            ),
                          ),
                        );
                      }
                    }
                    return CustomScrollView(slivers: slivers);
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

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: _PublicProductTile(
                          product: product,
                          onOpenMap: widget.onOpenMap,
                        ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            : Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
      ),
      title: Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        product.shelfName == null
            ? '₱${product.price} • Shelf unavailable'
            : '₱${product.price} • Shelf: ${product.shelfName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showProductDetails(context, ref, product),
            tooltip: 'Product info',
            icon: const Icon(Icons.info_outline),
          ),
          if (product.shelfId != null)
            IconButton(
              onPressed: () => onOpenMap?.call(product.shelfId),
              tooltip: 'Find on map',
              icon: const Icon(Icons.place_outlined),
            ),
        ],
      ),
      onTap: () => onOpenMap?.call(product.shelfId),
    );
  }

  void _showProductDetails(BuildContext context, WidgetRef ref, PublicProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.imageUrl != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl!.contains('api')
                            ? '${ref.read(apiBaseUrlProvider)}${product.imageUrl}'
                            : product.imageUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Text('Price: ₱${product.price}', style: Theme.of(context).textTheme.titleMedium),
              if (product.quantity != null)
                Text('In stock: ${product.quantity}', style: Theme.of(context).textTheme.bodyMedium),
              if (product.shelfName != null)
                Text('Location: ${product.shelfName}', style: Theme.of(context).textTheme.bodyMedium),
              if (product.barcode != null && product.barcode!.isNotEmpty)
                Text('Barcode: ${product.barcode}', style: Theme.of(context).textTheme.bodyMedium),
              if (product.description != null && product.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Description:', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(product.description!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
