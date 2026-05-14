// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(publicStoreService)
final publicStoreServiceProvider = PublicStoreServiceProvider._();

final class PublicStoreServiceProvider
    extends
        $FunctionalProvider<
          PublicStoreService,
          PublicStoreService,
          PublicStoreService
        >
    with $Provider<PublicStoreService> {
  PublicStoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicStoreServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicStoreServiceHash();

  @$internal
  @override
  $ProviderElement<PublicStoreService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PublicStoreService create(Ref ref) {
    return publicStoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PublicStoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PublicStoreService>(value),
    );
  }
}

String _$publicStoreServiceHash() =>
    r'b11cc4a513d1909e3727af96926ce7a01d38dfb5';

@ProviderFor(publicProductSearch)
final publicProductSearchProvider = PublicProductSearchFamily._();

final class PublicProductSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PublicProduct>>,
          List<PublicProduct>,
          FutureOr<List<PublicProduct>>
        >
    with
        $FutureModifier<List<PublicProduct>>,
        $FutureProvider<List<PublicProduct>> {
  PublicProductSearchProvider._({
    required PublicProductSearchFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'publicProductSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicProductSearchHash();

  @override
  String toString() {
    return r'publicProductSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<PublicProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PublicProduct>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return publicProductSearch(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicProductSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicProductSearchHash() =>
    r'a5878f9e0f24ce6f7453f5f0d9b3b5b2817dceca';

final class PublicProductSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<PublicProduct>>,
          (String, String)
        > {
  PublicProductSearchFamily._()
    : super(
        retry: null,
        name: r'publicProductSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PublicProductSearchProvider call(String slug, String query) =>
      PublicProductSearchProvider._(argument: (slug, query), from: this);

  @override
  String toString() => r'publicProductSearchProvider';
}

@ProviderFor(publicStoreInfo)
final publicStoreInfoProvider = PublicStoreInfoFamily._();

final class PublicStoreInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  PublicStoreInfoProvider._({
    required PublicStoreInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'publicStoreInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicStoreInfoHash();

  @override
  String toString() {
    return r'publicStoreInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as String;
    return publicStoreInfo(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicStoreInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicStoreInfoHash() => r'640634fd94300c81834bc9186bcff9aeab19d1ee';

final class PublicStoreInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, String> {
  PublicStoreInfoFamily._()
    : super(
        retry: null,
        name: r'publicStoreInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PublicStoreInfoProvider call(String slug) =>
      PublicStoreInfoProvider._(argument: slug, from: this);

  @override
  String toString() => r'publicStoreInfoProvider';
}
