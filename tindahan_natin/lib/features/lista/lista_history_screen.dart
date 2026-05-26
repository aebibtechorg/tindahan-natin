import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/lista/lista_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

class ListaHistoryScreen extends ConsumerWidget {
  const ListaHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista / Sales History'),
      ),
      body: myStoreAsync.when(
        data: (store) {
          if (store == null) return const Center(child: Text('Store not found.'));

          final historyAsync = ref.watch(listaHistoryProvider(store.id));

          return historyAsync.when(
            data: (entries) {
              if (entries.isEmpty) return const Center(child: Text('No transactions recorded yet.'));

              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      leading: Icon(
                        entry.isCredit ? Icons.event_note : Icons.receipt_long,
                        color: entry.isCredit ? Colors.orange : Colors.green,
                      ),
                      title: Text(entry.customerName ?? 'Walk-in Customer'),
                      subtitle: Text(
                        '${entry.createdAt.toLocal().toString().split('.')[0]} • By: ${entry.staffName}',
                      ),
                      trailing: Text(
                        '₱${entry.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      children: [
                        ...entry.items.map((item) => ListTile(
                          dense: true,
                          title: Text(item.productName),
                          subtitle: Text('₱${item.price} x ${item.quantity}'),
                          trailing: Text('₱${(item.price * item.quantity).toStringAsFixed(2)}'),
                        )),
                        OverflowBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _confirmDelete(context, ref, entry.id, store.id),
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              label: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id, String storeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('This will remove this record from history. Inventory will NOT be restored.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(listaServiceProvider).deleteListaEntry(id);
              ref.invalidate(listaHistoryProvider(storeId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
