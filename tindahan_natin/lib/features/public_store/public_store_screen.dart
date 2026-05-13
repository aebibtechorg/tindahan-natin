import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';

class PublicStoreScreen extends ConsumerStatefulWidget {
  final String slug;

  const PublicStoreScreen({super.key, required this.slug});

  @override
  ConsumerState<PublicStoreScreen> createState() => _PublicStoreScreenState();
}

class _PublicStoreScreenState extends ConsumerState<PublicStoreScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(publicProductSearchProvider(widget.slug, _query));
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(widget.slug));

    return Scaffold(
      appBar: AppBar(
        title: storeInfoAsync.when(
          data: (info) {
            final Store store = info['store'];
            return Text(store.name);
          },
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Tindahan Natin'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for products (e.g. Tomi)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _query = _searchController.text;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onSubmitted: (val) {
                setState(() {
                  _query = val;
                });
              },
            ),
          ),
          Expanded(
            child: searchAsync.when(
              data: (products) => products.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                            leading: product.imageUrl != null
                              ? Image.network('${ref.read(apiBaseUrlProvider)}${product.imageUrl}')
                              : const Icon(Icons.shopping_bag),
                          title: Text(product.name),
                          subtitle: Text('₱${product.price}'),
                          trailing: product.shelfId != null
                              ? ElevatedButton(
                                  onPressed: () {
                                    context.push('/store/${widget.slug}/map?shelfId=${product.shelfId}');
                                  },
                                  child: const Text('Find'),
                                )
                              : null,
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}