import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';

class StoreMapScreen extends ConsumerStatefulWidget {
  const StoreMapScreen({super.key});

  @override
  ConsumerState<StoreMapScreen> createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends ConsumerState<StoreMapScreen> {
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    const storeId = "1";
    final shelvesAsync = ref.watch(shelvesProvider(storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddShelfDialog(context, ref, storeId),
          ),
        ],
      ),
      body: shelvesAsync.when(
        data: (shelves) => InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(1000),
          minScale: 0.1,
          maxScale: 2.0,
          child: Stack(
            children: [
              // Grid or Background
              Container(
                width: 2000,
                height: 2000,
                color: Colors.grey[100],
              ),
              ...shelves.map((shelf) => Positioned(
                    left: shelf.x,
                    top: shelf.y,
                    child: DraggableShelf(shelf: shelf, storeId: storeId),
                  )),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddShelfDialog(BuildContext context, WidgetRef ref, String storeId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Shelf'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Shelf Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref.read(mapServiceProvider).createShelf({
                  'name': controller.text,
                  'storeId': storeId,
                  'x': 500.0, // Center initial position
                  'y': 500.0,
                });
                ref.invalidate(shelvesProvider(storeId));
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class DraggableShelf extends ConsumerStatefulWidget {
  final Shelf shelf;
  final String storeId;

  const DraggableShelf({super.key, required this.shelf, required this.storeId});

  @override
  ConsumerState<DraggableShelf> createState() => _DraggableShelfState();
}

class _DraggableShelfState extends ConsumerState<DraggableShelf> {
  late double x;
  late double y;

  @override
  void initState() {
    super.initState();
    x = widget.shelf.x;
    y = widget.shelf.y;
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: _ShelfWidget(name: widget.shelf.name, isDragging: true),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _ShelfWidget(name: widget.shelf.name),
      ),
      onDragEnd: (details) {
        // Need to convert global coordinates to local stack coordinates
        // For simplicity in MVP, we just update local state and sync
        // Real implementation would involve precise offset calculation
        setState(() {
          // This is a rough estimation for MVP
          x += details.offset.dx - details.velocity.pixelsPerSecond.dx / 100; 
          y += details.offset.dy - details.velocity.pixelsPerSecond.dy / 100;
        });
        
        ref.read(mapServiceProvider).updateShelf(widget.shelf.id, {
          'name': widget.shelf.name,
          'x': x,
          'y': y,
        });
      },
      child: _ShelfWidget(name: widget.shelf.name),
    );
  }
}

class _ShelfWidget extends StatelessWidget {
  final String name;
  final bool isDragging;

  const _ShelfWidget({required this.name, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDragging ? Colors.blue.withOpacity(0.5) : Colors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Material(
        color: Colors.transparent,
        child: Text(
          name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}