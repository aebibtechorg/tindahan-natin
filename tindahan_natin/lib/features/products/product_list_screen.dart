import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/categories/category.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) return const Center(child: Text('No store found'));
        final storeId = store.id;
        final productsAsync = ref.watch(productsProvider(storeId));
        final categoriesAsync = ref.watch(categoriesProvider(storeId));
        final shelvesAsync = ref.watch(shelvesProvider(storeId));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Products'),
            actions: [
              IconButton(
                icon: const Icon(Icons.category),
                tooltip: 'Categories',
                onPressed: () => context.push('/categories'),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.read(productsProvider(storeId).notifier).refresh(),
              ),
            ],
          ),
          body: productsAsync.when(
            data: (products) => RefreshIndicator(
              onRefresh: () => ref.read(productsProvider(storeId).notifier).refresh(),
              child: Builder(builder: (ctx) {
                final categoriesData = categoriesAsync.asData?.value;
                final shelvesData = shelvesAsync.asData?.value;

                if (categoriesData != null && shelvesData != null) {
                  if (products.isEmpty) return const Center(child: Text('No products yet.'));
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final cat = categoriesData.firstWhere(
                        (c) => c.id == product.categoryId,
                        orElse: () => Category(id: '', name: 'Uncategorized', storeId: ''),
                      );
                      final categoryName = cat.name;

                      final shelf = shelvesData.firstWhere(
                        (s) => s.id == (product.shelfId ?? ''),
                        orElse: () => Shelf(id: '', name: 'Unassigned', storeId: ''),
                      );
                      final shelfName = shelf.name;

                      return Dismissible(
                        key: Key('product_${product.id}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ref.read(productsProvider(storeId).notifier).deleteProduct(product.id);
                        },
                        child: ListTile(
                          leading: product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: '${ref.read(apiBaseUrlProvider)}${product.imageUrl}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                )
                              : const Icon(Icons.shopping_bag, size: 40),
                          title: Text(product.name),
                          subtitle: Text('₱${product.price} • $categoryName • $shelfName • Stock: ${product.quantity}'),
                          trailing: product.quantity < 5
                              ? const Chip(label: Text('Low Stock', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.red)
                              : const Icon(Icons.chevron_right),
                          onTap: () {
                            context.push('/inventory/edit/${product.id}');
                          },
                        ),
                      );
                    },
                  );
                }

                if (categoriesAsync.isLoading || shelvesAsync.isLoading) {
                  if (products.isEmpty) return const Center(child: Text('No products yet.'));
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Dismissible(
                        key: Key('product_${product.id}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ref.read(productsProvider(storeId).notifier).deleteProduct(product.id);
                        },
                        child: ListTile(
                          leading: product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: '${ref.read(apiBaseUrlProvider)}${product.imageUrl}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                )
                              : const Icon(Icons.shopping_bag, size: 40),
                          title: Text(product.name),
                          subtitle: Text('₱${product.price} • Loading category • Loading shelf • Stock: ${product.quantity}'),
                          trailing: product.quantity < 5
                              ? const Chip(label: Text('Low Stock', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.red)
                              : const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                }

                final catErr = categoriesAsync.whenOrNull(error: (e, s) => e);
                final shelfErr = shelvesAsync.whenOrNull(error: (e, s) => e);
                final errorMessage = catErr ?? shelfErr ?? 'Error loading resources';
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage.toString()),
                      const SizedBox(height: 8),
                      products.isEmpty
                          ? const Text('No products yet.')
                          : SizedBox(
                              height: 300,
                              child: ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return ListTile(
                                    leading: product.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: CachedNetworkImage(
                                              imageUrl: '${ref.read(apiBaseUrlProvider)}${product.imageUrl}',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(color: Colors.grey[200]),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          )
                                        : const Icon(Icons.shopping_bag, size: 40),
                                    title: Text(product.name),
                                    subtitle: Text('₱${product.price} • Unknown category/shelf • Stock: ${product.quantity}'),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                );
              }),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $e'),
                  ElevatedButton(
                    onPressed: () => ref.read(productsProvider(storeId).notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/inventory/add'),
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error loading store: $e'))),
    );
  }
}