import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/features/lista/lista_report_service.dart';
import 'package:tindahan_natin/features/lista/lista_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

part 'lista_history_screen.g.dart';

@riverpod
class ListaDateRange extends _$ListaDateRange {
  @override
  DateTimeRange? build() => null;

  void setRange(DateTimeRange? range) {
    state = range;
  }
}

class ListaHistoryScreen extends ConsumerWidget {
  const ListaHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStoreAsync = ref.watch(myStoreProvider);
    final dateRange = ref.watch(listaDateRangeProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lista History')),
            body: const Center(child: Text('Store not found.')),
          );
        }

        final historyAsync = ref.watch(listaHistoryProvider(
          store.id,
          startDate: dateRange?.start,
          // Add 1 day minus 1 microsecond to include the entire end date
          endDate: dateRange?.end.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1)),
        ));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lista / Sales History'),
            actions: [
              IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: () async {
                  final initialRange = ref.read(listaDateRangeProvider);
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    initialDateRange: initialRange,
                    firstDate: DateTime(2020),
                    lastDate: now,
                  );
                  if (picked != null) {
                    ref.read(listaDateRangeProvider.notifier).setRange(picked);
                  }
                },
                tooltip: 'Filter by Date',
              ),
              if (dateRange != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => ref.read(listaDateRangeProvider.notifier).setRange(null),
                  tooltip: 'Clear Filter',
                ),
              historyAsync.when(
                data: (entries) => IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: entries.isEmpty
                      ? null
                      : () => ListaReportService.generateAndDownloadPdf(
                            store: store,
                            entries: entries,
                          ),
                  tooltip: 'Download PDF Report',
                ),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
            ],
          ),
          body: historyAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const Center(child: Text('No transactions recorded yet.'));
              }

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
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Lista History')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(title: const Text('Lista History')),
        body: Center(child: Text('Error: $e')),
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
