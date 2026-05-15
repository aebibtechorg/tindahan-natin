import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
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
    // update UI immediately (e.g. clear icon visibility)
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
        if (store == null) return const Center(child: Text('No store found'));
        final storeId = store.id;
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
              // IconButton(
              //   icon: const Icon(Icons.category),
              //   tooltip: 'Categories',
              //   onPressed: () => context.push('/categories'),
              // ),
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchController.clear();
                      _query = '';
                    } else {
                      _isSearching = true;
                      // Focus the search field after frame
                      WidgetsBinding.instance.addPostFrameCallback((_) => _searchFocus.requestFocus());
                    }
                  });
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.refresh),
              //   onPressed: () => ref.read(productsProvider(storeId).notifier).refresh(),
              // ),
            ],
          ),
          body: displayAsync.when(
            data: (products) {
              final categoriesData = categoriesAsync.asData?.value;
              final shelvesData = shelvesAsync.asData?.value;

              if (categoriesAsync.isLoading || shelvesAsync.isLoading || categoriesData == null || shelvesData == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final catErr = categoriesAsync.whenOrNull(error: (e, s) => e);
              final shelfErr = shelvesAsync.whenOrNull(error: (e, s) => e);
              if (catErr != null || shelfErr != null) {
                final errorMessage = catErr ?? shelfErr ?? 'Error loading resources';
                return Center(child: Text(errorMessage.toString()));
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(productsProvider(storeId).notifier).refresh(),
                child: Builder(builder: (ctx) {
                  if (products.isEmpty) return const Center(child: Text('No products yet.'));
                  
                  const adInterval = 10;
                  final itemCount = products.length + (products.length / adInterval).floor();

                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final isAd = (index + 1) % (adInterval + 1) == 0;
                      if (isAd) {
                        return const InlineAdWidget();
                      }

                      final productIndex = index - (index / (adInterval + 1)).floor();
                      final product = products[productIndex];
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
                        ).animate()
                          .fadeIn(duration: const Duration(milliseconds: 300), delay: Duration(milliseconds: 30 * index))
                          .slideY(begin: 0.02, duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                      );
                    },
                  );
                }),
              );
            },
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
      error: (e, s) => Scaffold(body: Center(child: Text('Error loading store: $e'))),
    );
  }
}