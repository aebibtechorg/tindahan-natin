// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(saleService)
final saleServiceProvider = SaleServiceProvider._();

final class SaleServiceProvider
    extends $FunctionalProvider<SaleService, SaleService, SaleService>
    with $Provider<SaleService> {
  SaleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleServiceHash();

  @$internal
  @override
  $ProviderElement<SaleService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaleService create(Ref ref) {
    return saleService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaleService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaleService>(value),
    );
  }
}

String _$saleServiceHash() => r'fee41bfbacc684197f41b9cb05a05d63837ed46d';

@ProviderFor(salesList)
final salesListProvider = SalesListFamily._();

final class SalesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Sale>>,
          List<Sale>,
          FutureOr<List<Sale>>
        >
    with $FutureModifier<List<Sale>>, $FutureProvider<List<Sale>> {
  SalesListProvider._({
    required SalesListFamily super.from,
    required (String, {DateTime? from, DateTime? to}) super.argument,
  }) : super(
         retry: null,
         name: r'salesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesListHash();

  @override
  String toString() {
    return r'salesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Sale>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Sale>> create(Ref ref) {
    final argument = this.argument as (String, {DateTime? from, DateTime? to});
    return salesList(ref, argument.$1, from: argument.from, to: argument.to);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesListHash() => r'8ecc30026115cd0dad674b0bbe5271d9948de10b';

final class SalesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Sale>>,
          (String, {DateTime? from, DateTime? to})
        > {
  SalesListFamily._()
    : super(
        retry: null,
        name: r'salesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalesListProvider call(String storeId, {DateTime? from, DateTime? to}) =>
      SalesListProvider._(argument: (storeId, from: from, to: to), from: this);

  @override
  String toString() => r'salesListProvider';
}
