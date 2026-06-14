// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/core/realtime/signalr_service.dart';
import 'package:tindahan_natin/features/notifications/widgets/announcement_banner.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/shared/widgets/app_logo.dart';

/// AppShell provides a consistent scaffold with a modern AppBar
/// and a Material 3 `NavigationBar` for the main sections.
class AppShell extends ConsumerWidget {
  final Widget child;
  final String currentLocation;
  const AppShell({super.key, required this.child, required this.currentLocation});

  int _locationToIndex(String location) {
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/inventory')) return 2;
    if (location.startsWith('/store')) return 3;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, WidgetRef ref, int index) async {
    if (index == 0) {
      if (currentLocation != '/') context.go('/');
    } else if (index == 1) {
      if (currentLocation != '/map') context.go('/map');
    } else if (index == 2) {
      if (currentLocation != '/inventory') context.go('/inventory');
    } else if (index == 3) {
      final myStore = await ref.read(myStoreProvider.future);
      if (myStore != null) {
        final target = '/store/${myStore.slug}/products';
        if (currentLocation != target) context.go(target);
      } else {
        if (currentLocation != '/store') context.go('/store');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize global realtime connection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(realtimeClientProvider.notifier).connectGlobal();
    });

    final location = currentLocation;
    if (location.startsWith('/store')) {
      return child;
    }
    final selectedIndex = _locationToIndex(location);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const AppLogo(size: 36, showText: true),
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
          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  extended: true,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _onDestinationSelected(context, ref, index),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.map_outlined),
                      selectedIcon: Icon(Icons.map),
                      label: Text('Map'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2),
                      label: Text('Products'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.visibility_outlined),
                      selectedIcon: Icon(Icons.visibility),
                      label: Text('Public View'),
                    ),
                  ],
                ),
              if (isWide) const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Column(
                  children: [
                    const AnnouncementBanner(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutQuart,
                        switchOutCurve: Curves.easeInQuart,
                        child: child,
                        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _onDestinationSelected(context, ref, index),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
                    NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Products'),
                    NavigationDestination(icon: Icon(Icons.visibility_outlined), selectedIcon: Icon(Icons.visibility), label: 'Public View'),
                  ],
                ),
        );
      },
    );
  }
}
