// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listaService)
final listaServiceProvider = ListaServiceProvider._();

final class ListaServiceProvider
    extends $FunctionalProvider<ListaService, ListaService, ListaService>
    with $Provider<ListaService> {
  ListaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listaServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listaServiceHash();

  @$internal
  @override
  $ProviderElement<ListaService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListaService create(Ref ref) {
    return listaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListaService>(value),
    );
  }
}

String _$listaServiceHash() => r'b8e5a9d00a7d2ea4d72cf42d493582ea2aa13621';

@ProviderFor(listaHistory)
final listaHistoryProvider = ListaHistoryFamily._();

final class ListaHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ListaEntry>>,
          List<ListaEntry>,
          FutureOr<List<ListaEntry>>
        >
    with $FutureModifier<List<ListaEntry>>, $FutureProvider<List<ListaEntry>> {
  ListaHistoryProvider._({
    required ListaHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listaHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listaHistoryHash();

  @override
  String toString() {
    return r'listaHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ListaEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ListaEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return listaHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ListaHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listaHistoryHash() => r'1a7dec986686dd6e51b47f225d8e101fcff9fc35';

final class ListaHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ListaEntry>>, String> {
  ListaHistoryFamily._()
    : super(
        retry: null,
        name: r'listaHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListaHistoryProvider call(String storeId) =>
      ListaHistoryProvider._(argument: storeId, from: this);

  @override
  String toString() => r'listaHistoryProvider';
}

@ProviderFor(publicListaHistory)
final publicListaHistoryProvider = PublicListaHistoryFamily._();

final class PublicListaHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ListaEntry>>,
          List<ListaEntry>,
          FutureOr<List<ListaEntry>>
        >
    with $FutureModifier<List<ListaEntry>>, $FutureProvider<List<ListaEntry>> {
  PublicListaHistoryProvider._({
    required PublicListaHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'publicListaHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicListaHistoryHash();

  @override
  String toString() {
    return r'publicListaHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ListaEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ListaEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return publicListaHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicListaHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicListaHistoryHash() =>
    r'888ca24e6747c347070d9d914486e8a35c87f304';

final class PublicListaHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ListaEntry>>, String> {
  PublicListaHistoryFamily._()
    : super(
        retry: null,
        name: r'publicListaHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PublicListaHistoryProvider call(String storeId) =>
      PublicListaHistoryProvider._(argument: storeId, from: this);

  @override
  String toString() => r'publicListaHistoryProvider';
}
