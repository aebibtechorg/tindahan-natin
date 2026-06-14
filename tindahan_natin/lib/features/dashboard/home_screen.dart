import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tindahan_natin/core/config/public_web_config.dart';
import 'package:tindahan_natin/core/network/connectivity_provider.dart';
import 'package:tindahan_natin/core/realtime/signalr_service.dart';
import 'package:tindahan_natin/core/widgets/ad_widgets/interstitial_ad_provider.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/features/dashboard/dashboard_service.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/shared/widgets/app_logo.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Show interstitial ad on home screen access with frequency capping
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(isOnlineProvider)) {
        ref.read(interstitialAdProvider).showAdIfReady();
      }
    });
  }

  Future<void> _shareStore(Store store) async {
    final shareUrl = buildPublicStoreUrl(slug: store.slug);
    if (shareUrl == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Public store sharing is not configured')),
      );
      return;
    }

    final shareText = store.name.trim().isEmpty
        ? shareUrl
        : 'Check out ${store.name} on Tindahan Natin \n$shareUrl';

    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);
    final isOnline = ref.watch(isOnlineProvider);

    // Refresh when internet is back
    ref.listen(isOnlineProvider, (previous, next) {
      if (previous == false && next == true) {
        ref.invalidate(myStoreProvider);
        if (myStoreAsync.value != null) {
          ref.invalidate(storeStatsProvider(myStoreAsync.value!.id));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(myStoreProvider);
              if (myStoreAsync.value != null) {
                ref.invalidate(storeStatsProvider(myStoreAsync.value!.id));
              }
            },
          ),
        ],
        bottom: !isOnline
            ? PreferredSize(
                preferredSize: const Size.fromHeight(32),
                child: Container(
                  color: Colors.orange,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Text(
                    'Offline Mode - Showing cached data',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : null,
      ),
      body: myStoreAsync.when(
        data: (store) {
          if (store == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(size: 80),
                  const SizedBox(height: 16),
                  const Text('No store found for your account.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/settings'),
                    child: const Text('Go to Settings'),
                  ),
                ],
              ),
            );
          }

          final statsAsync = ref.watch(storeStatsProvider(store.id));
          
          // Connect to SignalR for real-time updates (only if online)
          if (isOnline) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(realtimeClientProvider.notifier).connect(store.id);
            });
          }

          return statsAsync.when(
            data: (stats) => LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
                
                final summaryCards = GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 0,
                  childAspectRatio: isWide ? 1.5 : 1.0,
                  children: [
                    _StatCard(
                      title: 'Total Sales',
                      value: '₱${stats.totalSales.toStringAsFixed(2)}',
                      icon: Icons.payments_outlined,
                      color: Colors.green,
                    ),
                    _StatCard(
                      title: 'Total Credit',
                      value: '₱${stats.totalCredit.toStringAsFixed(2)}',
                      icon: Icons.event_note,
                      color: Colors.orange,
                    ),
                    _StatCard(
                      title: 'Transactions',
                      value: '${stats.totalTransactions}',
                      icon: Icons.receipt_long_outlined,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      title: 'Performance',
                      value: '${stats.performanceChange >= 0 ? '+' : ''}${stats.performanceChange.toStringAsFixed(1)}%',
                      icon: stats.performanceChange >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: stats.performanceChange >= 0 ? Colors.purple : Colors.red,
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9));

                final alertsSection = stats.alerts.isEmpty ? const SizedBox.shrink() : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Alerts',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${stats.alerts.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...stats.alerts.map((alert) => Card(
                          color: Colors.red.withValues(alpha: 0.05),
                          margin: const EdgeInsets.only(bottom: 8, left: 0, right: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.warning_amber_rounded, color: Colors.white),
                            ),
                            title: Text(
                              alert.productName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(alert.message),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => context.push('/inventory/edit/${alert.productId}'),
                            ),
                          ),
                        ).animate().fadeIn().slideX(begin: 0.1)),
                    const SizedBox(height: 32),
                  ],
                );

                final dailyPerformanceSection = stats.dailyPerformance.isEmpty ? const SizedBox.shrink() : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Sales (Last 7 Days)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: stats.dailyPerformance.map((dp) {
                          final maxAmount = stats.dailyPerformance
                              .map((e) => e.amount)
                              .fold(0.0, (prev, element) => element > prev ? element : prev);
                          final heightFactor = maxAmount > 0 ? dp.amount / maxAmount : 0.0;
                          
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      '₱${dp.amount.toInt()}',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: (heightFactor * 60).clamp(4, 60),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${dp.date.month}/${dp.date.day}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );

                final quickActionsSection = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _QuickAction(
                            label: 'Products',
                            icon: Icons.inventory_2_outlined,
                            onTap: () => context.push('/inventory'),
                          ),
                          _QuickAction(
                            label: 'Map',
                            icon: Icons.map_outlined,
                            onTap: () => context.push('/map'),
                          ),
                          _QuickAction(
                            label: 'History',
                            icon: Icons.history,
                            onTap: () => context.push('/lista-history'),
                          ),
                          _QuickAction(
                            label: 'Public View',
                            icon: Icons.storefront,
                            onTap: () => context.push('/store/${store.slug}'),
                          ),
                          if (PublicWebConfig.hasBaseUrl)
                            _QuickAction(
                              label: 'Share',
                              icon: Icons.share_outlined,
                              onTap: () => _shareStore(store),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );

                final topProductsSection = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Products',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (stats.topProducts.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No sales data yet.'),
                      ))
                    else
                      ...stats.topProducts.map((p) => Card(
                        margin: const EdgeInsets.only(bottom: 8, left: 0, right: 0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(p.productName[0]),
                          ),
                          title: Text(p.productName),
                          subtitle: Text('${p.quantitySold} units sold'),
                          trailing: Text(
                            '₱${p.totalRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  ],
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${store.name}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ).animate().fadeIn().slideX(begin: -0.1),
                      const SizedBox(height: 24),
                      _StoreSetupChecklist(store: store),
                      const SizedBox(height: 24),
                      summaryCards,
                      
                      const SizedBox(height: 24),
                      const InlineAdWidget(),
                      const SizedBox(height: 32),

                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dailyPerformanceSection,
                                  topProductsSection,
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  alertsSection,
                                  quickActionsSection,
                                ],
                              ),
                            ),
                          ],
                        )
                      else ...[
                        alertsSection,
                        dailyPerformanceSection,
                        quickActionsSection,
                        topProductsSection,
                      ],
                    ],
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => AppErrorWidget(
              error: e,
              stackTrace: s,
              compact: true,
              onRetry: () => ref.invalidate(storeStatsProvider(store.id)),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => AppErrorWidget(
          error: e,
          stackTrace: s,
          onRetry: () => ref.invalidate(myStoreProvider),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _StoreSetupChecklist extends ConsumerStatefulWidget {
  final Store store;
  const _StoreSetupChecklist({required this.store});

  @override
  ConsumerState<_StoreSetupChecklist> createState() => _StoreSetupChecklistState();
}

class _StoreSetupChecklistState extends ConsumerState<_StoreSetupChecklist> {
  bool _isExpanded = true;

  Future<void> _shareStore(Store store) async {
    final shareUrl = buildPublicStoreUrl(slug: store.slug);
    if (shareUrl == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Public store sharing is not configured')),
      );
      return;
    }

    final shareText = store.name.trim().isEmpty
        ? shareUrl
        : 'Check out ${store.name} on Tindahan Natin \n$shareUrl';

    await SharePlus.instance.share(ShareParams(text: shareText));
    await ref.read(localStorageProvider).setStoreShared(store.id, true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storeId = widget.store.id;
    final categoriesAsync = ref.watch(categoriesProvider(storeId));
    final productsAsync = ref.watch(productsProvider(storeId));
    final shelvesAsync = ref.watch(shelvesProvider(storeId));

    if (categoriesAsync.isLoading || productsAsync.isLoading || shelvesAsync.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final categories = categoriesAsync.value ?? [];
    final products = productsAsync.value ?? [];
    final shelves = shelvesAsync.value ?? [];

    final hasStoreName = widget.store.name.isNotEmpty &&
        widget.store.name.toLowerCase() != 'new store' &&
        widget.store.name.toLowerCase() != 'my store';
    final hasCategory = categories.isNotEmpty;
    final hasProduct = products.isNotEmpty;
    final hasShelf = shelves.isNotEmpty;
    final hasShelfAssignment = products.any((p) => p.shelfId != null && p.shelfId!.isNotEmpty);
    final hasLowStockAlert = products.any((p) => p.minStockThreshold > 0);
    final hasShared = ref.watch(localStorageProvider).isStoreShared(storeId);

    final checklistItems = [
      _ChecklistItem(
        title: 'Name your store',
        subtitle: 'Change your store\'s generic name to a custom one.',
        isCompleted: hasStoreName,
        onTap: () => context.push('/settings/store'),
      ),
      _ChecklistItem(
        title: 'Create store shelves',
        subtitle: 'Draw and place visual shelves on your map.',
        isCompleted: hasShelf,
        onTap: () => context.go('/map'),
      ),
      _ChecklistItem(
        title: 'Create a category',
        subtitle: 'Group your items for better organization.',
        isCompleted: hasCategory,
        onTap: () => context.push('/categories'),
      ),
      _ChecklistItem(
        title: 'Add your first product',
        subtitle: 'Add details, price, and barcode for an item.',
        isCompleted: hasProduct,
        onTap: () => context.push('/inventory'),
      ),
      _ChecklistItem(
        title: 'Assign products to shelves',
        subtitle: 'Put products on shelves to easily locate them.',
        isCompleted: hasShelfAssignment,
        onTap: () => context.go('/map'),
      ),
      _ChecklistItem(
        title: 'Set a low stock threshold',
        subtitle: 'Get alerts when item quantity runs low.',
        isCompleted: hasLowStockAlert,
        onTap: () => context.go('/inventory'),
      ),
      _ChecklistItem(
        title: 'Share your store map',
        subtitle: 'Invite others or let customers view your shelves.',
        isCompleted: hasShared,
        onTap: () => _shareStore(widget.store),
      ),
    ];

    final completedCount = checklistItems.where((item) => item.isCompleted).length;
    final progressPercentage = completedCount / checklistItems.length;

    if (progressPercentage == 1.0) {
      return Card(
        elevation: 2,
        color: Colors.green.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.green.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.celebration, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Fully Configured!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('🎉 Great job! Your store is fully set up and ready for tracking.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().scale();
    }

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                    strokeWidth: 4,
                  ),
                  Text(
                    '${(progressPercentage * 100).round()}%',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            title: Text(
              'Store Setup Checklist',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$completedCount of ${checklistItems.length} steps completed',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checklistItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = checklistItems[index];
                return ListTile(
                  leading: Icon(
                    item.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: item.isCompleted ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      color: item.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text(item.subtitle),
                  trailing: item.isCompleted
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: item.onTap,
                        ),
                );
              },
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _ChecklistItem {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap;

  _ChecklistItem({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onTap,
  });
}
