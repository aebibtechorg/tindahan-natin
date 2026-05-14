import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

/// AppShell provides a consistent scaffold with a modern AppBar
/// and a Material 3 `NavigationBar` for the main sections.
class AppShell extends ConsumerWidget {
  final Widget child;
  final String currentLocation;
  const AppShell({Key? key, required this.child, required this.currentLocation}) : super(key: key);

  static final _routes = ['/', '/inventory', '/categories', '/map', '/settings'];

  int _locationToIndex(String location) {
    if (location.startsWith('/inventory')) return 1;
    if (location.startsWith('/categories')) return 2;
    if (location.startsWith('/map')) return 3;
    // if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = currentLocation;
    final selectedIndex = _locationToIndex(location);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.storefront, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Text('Tindahan Natin', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final myStore = await ref.read(myStoreProvider.future);
              if (myStore == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No store available')),
                );
                return;
              }
              context.push('/settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInQuart,
        child: child,
        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          final target = _routes[index];
          if (location != target) context.go(target);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Products'),
          NavigationDestination(icon: Icon(Icons.category_outlined), selectedIcon: Icon(Icons.category), label: 'Categories'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
          // NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
