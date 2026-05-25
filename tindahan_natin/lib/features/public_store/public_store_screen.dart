import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/public_store/sale_service.dart';

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

  void _showRecordSaleDialog(BuildContext context, WidgetRef ref, PublicProduct product, String storeId) {
    showDialog(
      context: context,
      builder: (context) => _QuickRecordSaleDialog(
        storeId: storeId,
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(publicProductSearchProvider(widget.slug, _query));
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(widget.slug));

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

              const adInterval = 10;
              final itemCount = products.length + (products.length / adInterval).floor();

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

                  return ListTile(
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: product.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrl!.contains('api') ? '${ref.read(apiBaseUrlProvider)}${product.imageUrl}' : product.imageUrl!,
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (product.shelfId != null)
                          IconButton(
                            onPressed: () => widget.onOpenMap?.call(product.shelfId),
                            tooltip: 'Find on map',
                            icon: const Icon(Icons.place_outlined),
                          ),
                        storeInfoAsync.when(
                          data: (info) {
                            final Store store = info['store'];
                            return IconButton(
                              onPressed: () => _showRecordSaleDialog(context, ref, product, store.id),
                              tooltip: 'Record sale',
                              icon: const Icon(Icons.add_shopping_cart),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (e, s) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    onTap: () => widget.onOpenMap?.call(product.shelfId),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

class _QuickRecordSaleDialog extends ConsumerStatefulWidget {
  final String storeId;
  final PublicProduct product;

  const _QuickRecordSaleDialog({required this.storeId, required this.product});

  @override
  ConsumerState<_QuickRecordSaleDialog> createState() => _QuickRecordSaleDialogState();
}

class _QuickRecordSaleDialogState extends ConsumerState<_QuickRecordSaleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  final _quantityController = TextEditingController(text: '1');
  final _customerNameController = TextEditingController();
  bool _isCredit = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Record Sale: ${widget.product.name}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (val) => double.tryParse(val ?? '') == null ? 'Invalid price' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => int.tryParse(val ?? '') == null ? 'Invalid quantity' : null,
              ),
              SwitchListTile(
                title: const Text('Lista'),
                value: _isCredit,
                onChanged: (val) => setState(() => _isCredit = val),
                contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              ),
              if (_isCredit)
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                  validator: (val) => _isCredit && (val == null || val.isEmpty) ? 'Required for credit' : null,
                ),
            ],
          ),
        ),
      ),
      actions: [
        // TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final price = double.parse(_priceController.text);
                final quantity = int.parse(_quantityController.text);

                await ref.read(saleServiceProvider).recordSale(
                  storeId: widget.storeId,
                  productName: _nameController.text,
                  priceAtSale: price,
                  quantity: quantity,
                  totalPrice: price * quantity,
                  isCredit: _isCredit,
                  customerName: _isCredit ? _customerNameController.text : null,
                  productId: widget.product.id,
                );
                ref.invalidate(salesListProvider(widget.storeId));
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            }
          },
          child: const Text('Record'),
        ),
      ],
    );
  }
}