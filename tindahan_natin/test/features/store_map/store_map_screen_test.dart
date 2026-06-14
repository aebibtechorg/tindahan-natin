import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/products/product.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:tindahan_natin/features/store_map/store_map_screen.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

class FakeLocalStorage implements LocalStorage {
  @override
  Future<void> cacheProducts(String storeId, List<Map<String, dynamic>> products) async {}
  @override
  Future<void> upsertCachedProduct(String storeId, Map<String, dynamic> record) async {}
  @override
  Future<void> removeCachedProduct(String storeId, String id) async {}
  @override
  List<Map<String, dynamic>>? getCachedProducts(String storeId) => [];
  @override
  Future<void> cacheRecords(String cacheKey, List<Map<String, dynamic>> records) async {}
  @override
  List<Map<String, dynamic>>? getCachedRecords(String cacheKey) => [];
  @override
  Map<String, dynamic>? getCachedRecordById(String cacheKey, String id) => null;
  @override
  Map<String, dynamic>? findCachedRecordByIdWithPrefix(String keyPrefix, String id) => null;
  @override
  Future<void> upsertCachedRecord(String cacheKey, Map<String, dynamic> record) async {}
  @override
  Future<void> removeCachedRecord(String cacheKey, String id) async {}
  @override
  Future<void> queueMutation(Map<String, dynamic> mutation) async {}
  @override
  List<Map<String, dynamic>> getPendingMutations() => [];
  @override
  Future<void> removePendingMutation(String mutationId) async {}
  @override
  Future<void> setOnboardingCompleted(bool value) async {}
  @override
  bool isOnboardingCompleted() => true;
  @override
  Future<void> setMapTutorialDismissed(bool value) async {}
  @override
  bool isMapTutorialDismissed() => true;
  @override
  Future<void> setStoreShared(String storeId, bool value) async {}
  @override
  bool isStoreShared(String storeId) => false;
  @override
  Future<void> clearCache() async {}
}

class FakeMapService implements MapService {
  final List<Shelf> shelves;
  final List<ProductLocation> locations;
  final List<Map<String, dynamic>> createdLocations = [];
  final List<String> deletedLocationIds = [];

  FakeMapService({required this.shelves, required this.locations});

  @override
  Future<List<Shelf>> getShelves(String storeId) async => shelves;

  @override
  Future<Shelf> createShelf(Map<String, dynamic> data) async {
    return Shelf.fromJson({...data, 'id': 'new-shelf-id'});
  }

  @override
  Future<void> updateShelf(String id, Map<String, dynamic> data, {String? storeId}) async {}

  @override
  Future<void> deleteShelf(String id, {String? storeId}) async {}

  @override
  Future<List<ProductLocation>> getProductLocations(String storeId) async => locations;

  @override
  Future<ProductLocation> createProductLocation(Map<String, dynamic> data) async {
    createdLocations.add(data);
    return ProductLocation(
      id: 'new-loc-id-${createdLocations.length}',
      productId: data['productId'],
      shelfId: data['shelfId'],
      position: data['position'] ?? 'default',
    );
  }

  @override
  Future<void> deleteProductLocation(String id, {String? storeId}) async {
    deletedLocationIds.add(id);
  }
}

class FakeProductsNotifier extends Products {
  List<Product> _products;
  FakeProductsNotifier(this._products);

  @override
  Future<List<Product>> build(String storeId) async => _products;

  @override
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    _products = _products.map((p) {
      if (p.id != id) return p;
      return Product.fromJson({
        ...p.toJson(),
        ...data,
      });
    }).toList();
    state = AsyncData(_products);
  }
}

void main() {
  testWidgets('StoreMapScreen edit shelf dialog renders assign/unassign list', (WidgetTester tester) async {
    final shelvesList = [
      const Shelf(id: 'shelf-1', name: 'Shelf A', storeId: 'store-1', x: 0.0, y: 0.0),
    ];
    final productsList = [
      const Product(
        id: 'product-1',
        name: 'Product A',
        price: 10.0,
        quantity: 100,
        categoryId: 'cat-1',
        storeId: 'store-1',
        shelfId: 'shelf-1',
      ),
      const Product(
        id: 'product-2',
        name: 'Product B',
        price: 15.0,
        quantity: 50,
        categoryId: 'cat-1',
        storeId: 'store-1',
      ),
    ];

    final fakeMapService = FakeMapService(shelves: shelvesList, locations: const []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageProvider.overrideWithValue(FakeLocalStorage()),
          myStoreProvider.overrideWith((ref) async => const Store(id: 'store-1', name: 'Test Store', slug: 'test-store', ownerId: 'owner-1')),
          shelvesProvider('store-1').overrideWith((ref) async => shelvesList),
          productsProvider('store-1').overrideWith(() => FakeProductsNotifier(productsList)),
          mapServiceProvider.overrideWithValue(fakeMapService),
        ],
        child: const MaterialApp(
          home: StoreMapScreen(),
        ),
      ),
    );

    // Initial load
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Open the Edit Shelf Dialog directly by calling the state method
    final dynamic state = tester.state(find.byType(StoreMapScreen));
    state.showEditShelfDialogPublicForTesting(shelvesList.first);
    
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify dialog elements
    expect(find.text('Edit Shelf'), findsOneWidget);
    expect(find.text('Products on Shelf'), findsOneWidget);

    // Verify assigned product is listed, unassigned is not
    expect(find.text('Product A'), findsOneWidget);
    expect(find.text('Product B'), findsNothing);

    // Tap "Add" button to open the "Add Product to Shelf" dialog
    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Search Dialog elements
    expect(find.text('Add Product to Shelf'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // One in edit dialog, one in search dialog

    // Product A (assigned) should be greyed out/disabled in the search dialog
    final searchDialogFinder = find.ancestor(
      of: find.text('Add Product to Shelf'),
      matching: find.byType(AlertDialog),
    );

    final productATile = tester.widget<ListTile>(
      find.descendant(
        of: searchDialogFinder,
        matching: find.ancestor(of: find.text('Product A'), matching: find.byType(ListTile)),
      ),
    );
    expect(productATile.enabled, isFalse);

    // Product B (unassigned) should be enabled in the search dialog
    final productBTile = tester.widget<ListTile>(
      find.descendant(
        of: searchDialogFinder,
        matching: find.ancestor(of: find.text('Product B'), matching: find.byType(ListTile)),
      ),
    );
    expect(productBTile.enabled, isTrue);

    // Enter search query "Product B"
    final searchFieldFinder = find.descendant(
      of: searchDialogFinder,
      matching: find.byType(TextField),
    );
    await tester.enterText(searchFieldFinder, 'Product B');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final productBTextFinder = find.descendant(
      of: find.byType(ListTile),
      matching: find.text('Product B'),
    );

    // Verify "Product A" is filtered out, but "Product B" remains
    expect(find.descendant(of: searchDialogFinder, matching: find.text('Product A')), findsNothing);
    expect(find.descendant(of: searchDialogFinder, matching: productBTextFinder), findsOneWidget);

    // Tap "Product B" to assign it
    await tester.tap(productBTextFinder);
    await tester.pumpAndSettle();

    // Verify search dialog closed (so only 1 textfield from the main edit dialog remains)
    expect(find.text('Add Product to Shelf'), findsNothing);

    // Verify product-2 has shelfId = 'shelf-1' in state
    final container = ProviderScope.containerOf(tester.element(find.byType(StoreMapScreen)));
    final productsAfterAdd = container.read(productsProvider('store-1')).value ?? [];
    final updatedProductB = productsAfterAdd.firstWhere((p) => p.id == 'product-2');
    expect(updatedProductB.shelfId, equals('shelf-1'));

    // Toggle Product A to unchecked/deleted (unassign it) from the main dialog
    final deleteButtonFinder = find.descendant(
      of: find.ancestor(of: find.text('Product A'), matching: find.byType(ListTile)),
      matching: find.byIcon(Icons.delete),
    );
    await tester.tap(deleteButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify product-1 has shelfId = null in state
    final productsAfterDelete = container.read(productsProvider('store-1')).value ?? [];
    final updatedProductA = productsAfterDelete.firstWhere((p) => p.id == 'product-1');
    expect(updatedProductA.shelfId, isNull);
  });
}
