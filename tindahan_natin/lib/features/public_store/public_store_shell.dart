import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
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
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            storeInfoAsync.when(
              data: (info) {
                final Store store = info['store'];
                return Text(store.name);
              },
              loading: () => const Text('Loading...'),
              error: (e, s) => const Text('Tindahan Natin'),
            ),
            if (authState.value != null)
              Text(
                'Staff: ${authState.value!.user.name ?? authState.value!.user.email}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
        actions: [
          authState.when(
            data: (creds) => creds != null
                ? IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout Crew'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        if (widget.navigationShell.currentIndex == 2) {
                          widget.navigationShell.goBranch(0);
                        }
                        await ref.read(authStateProvider.notifier).logout();
                      }
                    },
                    tooltip: 'Logout Staff',
                  )
                : IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => ref.read(authStateProvider.notifier).login(),
                    tooltip: 'Staff Login',
                  ),
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
          ),
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
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Products',
          ),
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          if (authState.value != null)
            const NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'Sales',
            ),
        ],
      ),
    );
  }
}
