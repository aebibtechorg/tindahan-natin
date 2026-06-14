import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/store_map/visual_shelf_selector.dart';

class FakeShelvesNotifier extends Notifier<List<Shelf>> {
  @override
  List<Shelf> build() => [];
  
  void setShelves(List<Shelf> shelves) {
    state = shelves;
  }
}

final fakeShelvesNotifierProvider = NotifierProvider<FakeShelvesNotifier, List<Shelf>>(FakeShelvesNotifier.new);

void main() {
  testWidgets('VisualShelfSelector renders shelves and allows selection', (WidgetTester tester) async {
    final shelvesList = [
      const Shelf(id: 'shelf-1', name: 'Shelf A', storeId: 'store-1', x: 0.0, y: 0.0),
      const Shelf(id: 'shelf-2', name: 'Shelf B', storeId: 'store-1', x: 100.0, y: 200.0),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shelvesProvider('store-1').overrideWith((ref) async => shelvesList),
        ],
        child: const MaterialApp(
          home: VisualShelfSelector(
            storeId: 'store-1',
          ),
        ),
      ),
    );

    // Let the async provider resolve
    await tester.pumpAndSettle();

    // Verify both shelves are rendered
    expect(find.text('Shelf A'), findsOneWidget);
    expect(find.text('Shelf B'), findsOneWidget);
  });

  testWidgets('VisualShelfSelector correctly configures initial view when shelves load late', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shelvesProvider('store-1').overrideWith((ref) async => ref.watch(fakeShelvesNotifierProvider)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: VisualShelfSelector(
                storeId: 'store-1',
              ),
            ),
          ),
        ),
      ),
    );

    // Initial build with empty shelves list
    await tester.pumpAndSettle();

    // Now update shelves to contain a shelf far from center (e.g., x: 1000, y: 1000)
    final container = ProviderScope.containerOf(tester.element(find.byType(VisualShelfSelector)));
    container.read(fakeShelvesNotifierProvider.notifier).setShelves([
      const Shelf(id: 'shelf-1', name: 'Far Shelf', storeId: 'store-1', x: 1000.0, y: 1000.0),
    ]);

    // Re-build/re-layout
    await tester.pumpAndSettle();

    // Get the transformation matrix of the InteractiveViewer
    final InteractiveViewer viewer = tester.widget(find.byType(InteractiveViewer));
    final controller = viewer.transformationController!;
    final translation = controller.value.getTranslation();

    // If it centered on the shelf at (1000, 1000), translation should focus on it.
    // Viewport size is 400 x 600. Center is 200, 300.
    // Target position is x: 1000 + 50000 = 51000, y: 1000 + 50000 = 51000.
    // Expected translation: x = 200 - 51000 = -50800, y = 300 - 51000 = -50700.
    // With AppBar height constraints, actual y translation becomes -50728.0.
    print('Translation: $translation');
    expect(translation.x, equals(-50800.0));
    expect(translation.y, equals(-50728.0));
  });
}
