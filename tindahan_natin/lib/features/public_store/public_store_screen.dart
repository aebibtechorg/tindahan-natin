import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // update UI immediately for suffix icon visibility
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
            data: (products) => products.isEmpty
                ? const Center(child: Text('No products found.'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ListTile(
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '${ref.read(apiBaseUrlProvider)}${product.imageUrl}',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.shopping_bag),
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          product.shelfName == null
                              ? '₱${product.price} • Shelf unavailable'
                              : '₱${product.price} • Shelf: ${product.shelfName}',
                        ),
                        trailing: product.shelfId != null
                            ? SizedBox(
                                width: 48,
                                child: IconButton(
                                  onPressed: () => widget.onOpenMap?.call(product.shelfId),
                                  tooltip: 'Find on map',
                                  icon: const Icon(Icons.place_outlined),
                                ),
                              )
                            : null,
                        onTap: () => widget.onOpenMap?.call(product.shelfId),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}