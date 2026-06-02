import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/core/realtime/signalr_service.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/lista/lista_service.dart';
import 'package:tindahan_natin/features/notifications/widgets/announcement_banner.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(realtimeClientProvider.notifier).connectGlobal();
    });
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(widget.slug));
    final authState = ref.watch(authStateProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: authState.value != null,
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
                  ref.invalidate(publicListaHistoryProvider);
                },
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  extended: true,
                  selectedIndex: widget.navigationShell.currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.storefront_outlined),
                      selectedIcon: Icon(Icons.storefront),
                      label: Text('Products'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.map_outlined),
                      selectedIcon: Icon(Icons.map),
                      label: Text('Map'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.event_note_outlined),
                      selectedIcon: Icon(Icons.event_note),
                      label: Text('Lista'),
                    ),
                  ],
                ),
              if (isWide) const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Column(
                  children: [
                    const AnnouncementBanner(),
                    Expanded(child: widget.navigationShell),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: widget.navigationShell.currentIndex,
                  onDestinationSelected: _onDestinationSelected,
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
                    NavigationDestination(
                      icon: Icon(Icons.event_note_outlined),
                      selectedIcon: Icon(Icons.event_note),
                      label: 'Lista',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
