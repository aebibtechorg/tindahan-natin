import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/features/products/product.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/categories/category.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animations/animations.dart';
import 'package:tindahan_natin/features/products/add_product_screen.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/realtime/signalr_service.dart';
import 'package:tindahan_natin/shared/widgets/empty_state_widget.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _isSearching = false;
  final FocusNode _searchFocus = FocusNode();

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
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) return const Scaffold(body: Center(child: Text('No store found')));
        final storeId = store.id;

        // Connect to SignalR for real-time updates
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(realtimeClientProvider.notifier).connect(storeId);
        });

        final productsAsync = ref.watch(productsProvider(storeId));
        final categoriesAsync = ref.watch(categoriesProvider(storeId));
        final shelvesAsync = ref.watch(shelvesProvider(storeId));

        final displayAsync = _query.isEmpty ? productsAsync : ref.watch(productSearchProvider('$storeId::$_query'));

        return Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search products (name, barcode, description)',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
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
                          : null,
                    ),
                  )
                : const Text('Products'),
            actions: [
              IconButton(
                icon: const Icon(Icons.category),
                tooltip: 'Manage Categories',
                onPressed: () => context.push('/categories'),
              ),
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _debounce?.cancel();
                      _isSearching = false;
                      _searchController.clear();
                      _query = '';
                    } else {
                      _isSearching = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) => _searchFocus.requestFocus());
                    }
                  });
                },
              ),
            ],
          ),
          body: displayAsync.when(
            data: (products) {
              final categoriesData = categoriesAsync.asData?.value;
              final shelvesData = shelvesAsync.asData?.value;

              if (categoriesAsync.isLoading || shelvesAsync.isLoading || categoriesData == null || shelvesData == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(productsProvider(storeId).notifier).refresh(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    
                    if (products.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.inventory_2_outlined,
                        title: 'Your Store is Empty',
                        description: 'Add your first product to start tracking your inventory.',
                        actionLabel: 'Add Product',
                        onActionPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddProductScreen(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                      );
                    }
                    
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
                                maxCrossAxisExtent: 450,
                                mainAxisExtent: 100,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = chunk[index];
                                  return _ProductTile(
                                    product: product,
                                    categoryName: categoriesData.firstWhere(
                                      (c) => c.id == product.categoryId,
                                      orElse: () => Category(id: '', name: 'Uncategorized', storeId: ''),
                                    ).name,
                                    shelfName: shelvesData.firstWhere(
                                      (s) => s.id == (product.shelfId ?? ''),
                                      orElse: () => Shelf(id: '', name: 'Unassigned', storeId: ''),
                                    ).name,
                                    index: i + index,
                                    onTap: () => context.push('/inventory/edit/${product.id}'),
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
                          return const Column(
                            children: [
                              InlineAdWidget(),
                              Divider(),
                            ],
                          );
                        }

                        final productIndex = index - (index / (adInterval + 1)).floor();
                        final product = products[productIndex];
                        return _ProductTile(
                          product: product,
                          categoryName: categoriesData.firstWhere(
                            (c) => c.id == product.categoryId,
                            orElse: () => Category(id: '', name: 'Uncategorized', storeId: ''),
                          ).name,
                          shelfName: shelvesData.firstWhere(
                            (s) => s.id == (product.shelfId ?? ''),
                            orElse: () => Shelf(id: '', name: 'Unassigned', storeId: ''),
                          ).name,
                          index: index,
                          onTap: () => context.push('/inventory/edit/${product.id}'),
                          onDelete: () => ref.read(productsProvider(storeId).notifier).deleteProduct(product.id),
                        );
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => AppErrorWidget(
              error: e,
              stackTrace: s,
              onRetry: () => ref.read(productsProvider(storeId).notifier).refresh(),
            ),
          ),
          floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 450),
            closedElevation: 6.0,
            openElevation: 6.0,
            closedShape: const CircleBorder(),
            closedColor: Theme.of(context).colorScheme.primary,
            closedBuilder: (context, open) => FloatingActionButton(
              onPressed: open,
              child: const Icon(Icons.add),
            ),
            openBuilder: (context, _) => const AddProductScreen(),
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
}

class _ProductTile extends ConsumerWidget {
  final Product product;
  final String categoryName;
  final String shelfName;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _ProductTile({
    required this.product,
    required this.categoryName,
    required this.shelfName,
    required this.index,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = ListTile(
      leading: product.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl!.startsWith('http')
                    ? product.imageUrl!
                    : '${ref.read(apiBaseUrlProvider)}${product.imageUrl}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
          : const Icon(Icons.shopping_bag, size: 40),
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '₱${product.price} • $categoryName • $shelfName • Stock: ${product.quantity}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: product.quantity < product.minStockThreshold
          ? const Chip(
              label: Text('Low Stock', style: TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: Colors.red,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300), delay: Duration(milliseconds: 30 * index))
      .slideY(begin: 0.02, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

    if (onDelete == null) return Card(margin: EdgeInsets.zero, child: tile);

    return Dismissible(
      key: Key('product_${product.id}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text('Are you sure you want to delete ${product.name}?\nThis action cannot be undone.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) => onDelete?.call(),
      child: tile,
    );
  }
}
