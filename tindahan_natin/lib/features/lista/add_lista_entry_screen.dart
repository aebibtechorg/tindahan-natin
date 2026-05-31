import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/features/lista/lista_service.dart';
import 'package:tindahan_natin/features/lista/lista_settings.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/shared/utils/snackbar_utils.dart';

class AddListaEntryScreen extends ConsumerStatefulWidget {
  final String slug;

  const AddListaEntryScreen({super.key, required this.slug});

  @override
  ConsumerState<AddListaEntryScreen> createState() => _AddListaEntryScreenState();
}

class _AddListaEntryScreenState extends ConsumerState<AddListaEntryScreen> {
  final _customerController = TextEditingController();
  bool _isCredit = false;
  final List<Map<String, dynamic>> _items = [];

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  void _addItem(PublicProduct product) {
    setState(() {
      final existingIndex = _items.indexWhere((item) => item['productId'] == product.id);
      if (existingIndex >= 0) {
        _items[existingIndex]['quantity']++;
      } else {
        _items.add({
          'productId': product.id,
          'productName': product.name,
          'price': product.price,
          'quantity': 1,
        });
      }
    });
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQuantity = (_items[index]['quantity'] as int) + delta;
      if (newQuantity > 0) {
        _items[index]['quantity'] = newQuantity;
      } else {
        _items.removeAt(index);
      }
    });
  }

  double get _total => _items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  Future<void> _submit() async {
    final staffName = ref.read(listaStaffNameProvider).value;
    if (staffName == null || staffName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff name is required')));
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item')));
      return;
    }

    final storeInfo = await ref.read(publicStoreInfoProvider(widget.slug).future);
    final String storeId = storeInfo['store'].id;

    final data = {
      'storeId': storeId,
      'staffName': staffName,
      'customerName': _customerController.text.trim().isEmpty ? null : _customerController.text.trim(),
      'isCredit': _isCredit,
      'items': _items.map((item) => {
        'productId': item['productId'],
        'quantity': item['quantity'],
      }).toList(),
    };

    try {
      await ref.read(listaServiceProvider).createListaEntry(data);
      if (mounted) {
        SnackBarUtils.showSuccess(context, 'Lista saved!');
        ref.invalidate(publicListaHistoryProvider);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffName = ref.watch(listaStaffNameProvider).value ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Sale'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 8),
                Text('Recording as: $staffName', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _customerController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name (Optional)',
                      hintText: 'For credit/utang transactions',
                      prefixIcon: Icon(Icons.face),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Is Credit (Pa-lista/Utang)?'),
                    subtitle: const Text('Check this if the items are not paid yet'),
                    value: _isCredit,
                    onChanged: (val) => setState(() => _isCredit = val),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('Add products to start recording.')),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text(item['productName']),
                        subtitle: Text('₱${item['price']} each'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _updateQuantity(index, -1),
                              tooltip: 'Decrease quantity',
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              constraints: const BoxConstraints(minWidth: 40),
                              child: Text(
                                '${item['quantity']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _updateQuantity(index, 1),
                              tooltip: 'Increase quantity',
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: Text(
                                '₱${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount:', style: TextStyle(fontSize: 18)),
                      Text(
                        '₱${_total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showProductPicker(context),
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add Product'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Sale'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _ProductPicker(
          slug: widget.slug,
          onPicked: (product) {
            _addItem(product);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _ProductPicker extends ConsumerStatefulWidget {
  final String slug;
  final ValueChanged<PublicProduct> onPicked;

  const _ProductPicker({required this.slug, required this.onPicked});

  @override
  ConsumerState<_ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends ConsumerState<_ProductPicker> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
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
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
            onChanged: (val) => setState(() => _query = val),
          ),
        ),
        Expanded(
          child: searchAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text(product.name),
                    subtitle: Text('₱${product.price}'),
                    onTap: () => widget.onPicked(product),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => AppErrorWidget(
              error: e,
              stackTrace: s,
              compact: true,
              onRetry: () => ref.invalidate(publicProductSearchProvider(widget.slug, _query)),
            ),
          ),
        ),
      ],
    );
  }
}
