import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';

class PublicStoreShell extends ConsumerStatefulWidget {
  final String slug;
  final StatefulNavigationShell navigationShell;

  const PublicStoreShell({
    super.key,
    required this.slug,
    required this.navigationShell,
  });

  @override
  ConsumerState<PublicStoreShell> createState() => _PublicStoreShellState();
}

class _PublicStoreShellState extends ConsumerState<PublicStoreShell> {
  @override
  Widget build(BuildContext context) {
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(widget.slug));

    return Scaffold(
      appBar: AppBar(
        title: storeInfoAsync.when(
          data: (info) {
            final Store store = info['store'];
            return Text(store.name);
          },
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Tindahan Natin'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(publicStoreInfoProvider(widget.slug));
              ref.invalidate(publicProductSearchProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
      ),
    );
  }
}
