import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const storeId = "1"; 
    final productsAsync = ref.watch(productsProvider(storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productsProvider(storeId).notifier).refresh(),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) => RefreshIndicator(
          onRefresh: () => ref.read(productsProvider(storeId).notifier).refresh(),
          child: products.isEmpty
              ? const Center(child: Text('No products yet.'))
              : ListView.builder(
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
                        subtitle: Text('₱${product.price} - Stock: ${product.quantity}'),
                        trailing: product.quantity < 5 
                            ? const Chip(label: Text('Low Stock', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.red)
                            : const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to edit product
                        },
                      ),
                    );
                  },
                ),
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
  }
}