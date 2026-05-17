import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/public_store/public_map_screen.dart';
import 'package:tindahan_natin/features/public_store/public_store_screen.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';

class PublicStoreShell extends ConsumerStatefulWidget {
  final String slug;
  final String currentLocation;
  final String? highlightShelfId;

  const PublicStoreShell({
    super.key,
    required this.slug,
    required this.currentLocation,
    this.highlightShelfId,
  });

  @override
  ConsumerState<PublicStoreShell> createState() => _PublicStoreShellState();
}

class _PublicStoreShellState extends ConsumerState<PublicStoreShell> {
  String? _lastHighlightShelfId;

  @override
  void initState() {
    super.initState();
    _lastHighlightShelfId = widget.highlightShelfId;
  }

  @override
  void didUpdateWidget(covariant PublicStoreShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.slug != oldWidget.slug) {
      _lastHighlightShelfId = widget.highlightShelfId;
      return;
    }
    if (widget.highlightShelfId != null && widget.highlightShelfId != _lastHighlightShelfId) {
      _lastHighlightShelfId = widget.highlightShelfId;
    }
  }

  int get _selectedIndex => widget.currentLocation.endsWith('/map') ? 1 : 0;

  String _storePath() => '/store/${Uri.encodeComponent(widget.slug)}';

  String _mapPath() {
    final basePath = '${_storePath()}/map';
    final shelfId = _lastHighlightShelfId;
    if (shelfId == null || shelfId.isEmpty) {
      return basePath;
    }
    return '$basePath?shelfId=${Uri.encodeComponent(shelfId)}';
  }

  void _openProductsTab() {
    final target = _storePath();
    if (widget.currentLocation != target) {
      context.go(target);
    }
  }

  void _openMapTab() {
    final target = _mapPath();
    if (widget.currentLocation != target) {
      context.go(target);
    }
  }

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
              ref.invalidate(publicStoreInfoProvider);
              ref.invalidate(publicProductSearchProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PublicStoreScreen(
            slug: widget.slug,
            onOpenMap: (shelfId) {
              if (shelfId != null && shelfId.isNotEmpty) {
                _lastHighlightShelfId = shelfId;
              }
              _openMapTab();
            },
          ),
          PublicMapScreen(
            slug: widget.slug,
            highlightShelfId: widget.highlightShelfId ?? _lastHighlightShelfId,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            _openProductsTab();
          } else {
            _openMapTab();
          }
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
