import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/features/public_store/sale.dart';
import 'package:tindahan_natin/features/public_store/sale_service.dart';

class ListaScreen extends ConsumerWidget {
  final String slug;

  const ListaScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(slug));

    return storeInfoAsync.when(
      data: (info) {
        final Store store = info['store'];
        final salesAsync = ref.watch(salesListProvider(store.id));

        return Scaffold(
          body: salesAsync.when(
            data: (sales) {
              if (sales.isEmpty) {
                return const Center(child: Text('No sales recorded today.'));
              }

              final currencyFormat = NumberFormat.currency(symbol: '₱');
              final dateFormat = DateFormat.yMMMMd();
              final timeFormat = DateFormat.Hm();

              final groupedItems = <dynamic>[];
              DateTime? lastDate;

              for (final sale in sales) {
                final date = DateTime(
                  sale.createdAt.year,
                  sale.createdAt.month,
                  sale.createdAt.day,
                );
                if (lastDate == null || date != lastDate) {
                  groupedItems.add(date);
                  lastDate = date;
                }
                groupedItems.add(sale);
              }

              return ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  final item = groupedItems[index];

                  if (item is DateTime) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        dateFormat.format(item),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    );
                  }

                  final sale = item as Sale;
                  final soldByLabel = sale.soldByName ?? 'Unknown Staff';
                  
                  return ListTile(
                    title: Text(sale.productName),
                    subtitle: Text(
                      '${sale.quantity} x ${currencyFormat.format(sale.priceAtSale)} = ${currencyFormat.format(sale.totalPrice)}\n'
                      '${sale.isCredit ? "Credit: ${sale.customerName ?? 'Unknown'}" : "Paid"} • Sold by: $soldByLabel',
                    ),
                    trailing: Text(timeFormat.format(sale.createdAt)),
                    isThreeLine: true,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showRecordSaleDialog(context, ref, store.id),
            child: const Icon(Icons.add_shopping_cart),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  void _showRecordSaleDialog(BuildContext context, WidgetRef ref, String storeId) {
    showDialog(
      context: context,
      builder: (context) => _RecordSaleDialog(storeId: storeId),
    );
  }
}

class _RecordSaleDialog extends ConsumerStatefulWidget {
  final String storeId;

  const _RecordSaleDialog({required this.storeId});

  @override
  ConsumerState<_RecordSaleDialog> createState() => _RecordSaleDialogState();
}

class _RecordSaleDialogState extends ConsumerState<_RecordSaleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _customerNameController = TextEditingController();
  bool _isCredit = false;

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
      title: const Text('Record Sale'),
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
