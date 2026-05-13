// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mapService)
final mapServiceProvider = MapServiceProvider._();

final class MapServiceProvider
    extends $FunctionalProvider<MapService, MapService, MapService>
    with $Provider<MapService> {
  MapServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapServiceHash();

  @$internal
  @override
  $ProviderElement<MapService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapService create(Ref ref) {
    return mapService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapService>(value),
    );
  }
}

String _$mapServiceHash() => r'142cfd7e8ac0d9b848254651ef9027c0e66288eb';

@ProviderFor(shelves)
final shelvesProvider = ShelvesFamily._();

final class ShelvesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shelf>>,
          List<Shelf>,
          FutureOr<List<Shelf>>
        >
    with $FutureModifier<List<Shelf>>, $FutureProvider<List<Shelf>> {
  ShelvesProvider._({
    required ShelvesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shelvesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shelvesHash();

  @override
  String toString() {
    return r'shelvesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Shelf>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shelf>> create(Ref ref) {
    final argument = this.argument as int;
    return shelves(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShelvesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shelvesHash() => r'eca94903260fe2599f53e1863ab6ccc17ce9f70c';

final class ShelvesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Shelf>>, int> {
  ShelvesFamily._()
    : super(
        retry: null,
        name: r'shelvesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShelvesProvider call(int storeId) =>
      ShelvesProvider._(argument: storeId, from: this);

  @override
  String toString() => r'shelvesProvider';
}

@ProviderFor(productLocations)
final productLocationsProvider = ProductLocationsFamily._();

final class ProductLocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductLocation>>,
          List<ProductLocation>,
          FutureOr<List<ProductLocation>>
        >
    with
        $FutureModifier<List<ProductLocation>>,
        $FutureProvider<List<ProductLocation>> {
  ProductLocationsProvider._({
    required ProductLocationsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productLocationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productLocationsHash();

  @override
  String toString() {
    return r'productLocationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProductLocation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductLocation>> create(Ref ref) {
    final argument = this.argument as int;
    return productLocations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductLocationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productLocationsHash() => r'46c34b38946b889f8a3e7c5b95a90b30f2206646';

final class ProductLocationsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProductLocation>>, int> {
  ProductLocationsFamily._()
    : super(
        retry: null,
        name: r'productLocationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductLocationsProvider call(int storeId) =>
      ProductLocationsProvider._(argument: storeId, from: this);

  @override
  String toString() => r'productLocationsProvider';
}
