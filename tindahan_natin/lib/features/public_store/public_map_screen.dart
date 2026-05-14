import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';

class PublicMapScreen extends ConsumerWidget {
  final String slug;
  final String? highlightShelfId;

  const PublicMapScreen({super.key, required this.slug, this.highlightShelfId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeInfoAsync = ref.watch(publicStoreInfoProvider(slug));

    return SizedBox.expand(
      child: storeInfoAsync.when(
        data: (info) {
          final List<Shelf> shelves = info['shelves'];

          return InteractiveViewer(
            clipBehavior: Clip.none,
            boundaryMargin: const EdgeInsets.all(4000),
            minScale: 0.05,
            maxScale: 4.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 6000,
                  height: 6000,
                  color: Colors.grey[100],
                ),
                ...shelves.map((shelf) {
                  final isHighlighted = shelf.id == highlightShelfId;
                  return Positioned(
                    left: shelf.x,
                    top: shelf.y,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isHighlighted ? Colors.orange : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        border: isHighlighted
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Text(
                        shelf.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}