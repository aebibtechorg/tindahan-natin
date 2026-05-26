import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/core/realtime/signalr_service.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/lista/lista_entry.dart';
import 'package:tindahan_natin/features/lista/lista_service.dart';
import 'package:tindahan_natin/features/lista/lista_settings.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';

class PublicListaScreen extends ConsumerWidget {
  final String slug;

  const PublicListaScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(slug));
    final staffNameAsync = ref.watch(listaStaffNameProvider);
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      body: staffNameAsync.when(
        data: (staffName) {
          // If no staff name is set, and user is logged in, pre-fill and set it.
          if (staffName == null && authAsync.value != null) {
            final userName = authAsync.value?.user.name;
            if (userName != null && userName.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(listaStaffNameProvider.notifier).set(userName);
              });
              return const Center(child: CircularProgressIndicator());
            }
          }

          if (staffName == null) {
            return _StaffNameEntry(slug: slug);
          }

          return storeInfoAsync.when(
            data: (info) {
              final String storeId = info['store'].id;
              
              // Connect to SignalR for real-time updates
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(realtimeClientProvider.notifier).connect(storeId);
              });

              final historyAsync = ref.watch(publicListaHistoryProvider(storeId));

              return historyAsync.when(
                data: (entries) {
                  return Column(
                    children: [
                      _StaffHeader(staffName: staffName),
                      Expanded(
                        child: entries.isEmpty
                            ? const Center(child: Text('No transactions recorded yet.'))
                            : _HistoryList(entries: entries),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: staffNameAsync.value != null
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/store/$slug/lista/add'),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('New Sale'),
            )
          : null,
    );
  }
}

class _StaffHeader extends ConsumerWidget {
  final String staffName;

  const _StaffHeader({required this.staffName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          const Icon(Icons.person_outline),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Staff: $staffName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => ref.read(listaStaffNameProvider.notifier).clear(),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class _StaffNameEntry extends ConsumerStatefulWidget {
  final String slug;

  const _StaffNameEntry({required this.slug});

  @override
  ConsumerState<_StaffNameEntry> createState() => _StaffNameEntryState();
}

class _StaffNameEntryState extends ConsumerState<_StaffNameEntry> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Who is recording sales today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Staff Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref.read(listaStaffNameProvider.notifier).set(val.trim());
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  ref.read(listaStaffNameProvider.notifier).set(_controller.text.trim());
                }
              },
              child: const Text('Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<ListaEntry> entries;

  const _HistoryList({required this.entries});

  @override
  Widget build(BuildContext context) {
    // Group entries by date
    final Map<String, List<ListaEntry>> groupedEntries = {};
    for (final entry in entries) {
      final date = entry.createdAt.toLocal().toString().split(' ')[0];
      groupedEntries.putIfAbsent(date, () => []).add(entry);
    }

    final dates = groupedEntries.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final dayEntries = groupedEntries[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                date,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            ...dayEntries.map((entry) => _EntryCard(entry: entry)),
          ],
        );
      },
    );
  }
}

class _EntryCard extends ConsumerWidget {
  final ListaEntry entry;

  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          entry.isCredit ? Icons.event_note : Icons.receipt_long,
          color: entry.isCredit ? Colors.orange : Colors.green,
        ),
        title: Text(entry.customerName ?? 'Walk-in Customer'),
        subtitle: Text(
          '${entry.createdAt.toLocal().toString().split(' ')[1].split('.')[0]} • By: ${entry.staffName}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₱${entry.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (entry.isCredit)
              const Text(
                'UNPAID',
                style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        children: [
          ...entry.items.map((item) => ListTile(
                dense: true,
                title: Text(item.productName),
                subtitle: Text('₱${item.price} x ${item.quantity}'),
                trailing: Text('₱${(item.price * item.quantity).toStringAsFixed(2)}'),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final action = entry.isCredit ? 'paid' : 'unpaid';
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Mark as $action?'),
                        content: Text('Are you sure you want to mark this transaction as $action?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes, $action')),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      try {
                        await ref.read(listaServiceProvider).toggleCreditStatus(entry.id);
                        ref.invalidate(publicListaHistoryProvider);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    }
                  },
                  icon: Icon(entry.isCredit ? Icons.check_circle_outline : Icons.history),
                  label: Text(entry.isCredit ? 'Mark as Paid' : 'Mark as Unpaid'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
