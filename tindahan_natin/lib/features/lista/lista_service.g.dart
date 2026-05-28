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
    required (String, {DateTime? startDate, DateTime? endDate}) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ListaEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ListaEntry>> create(Ref ref) {
    final argument =
        this.argument as (String, {DateTime? startDate, DateTime? endDate});
    return listaHistory(
      ref,
      argument.$1,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
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

String _$listaHistoryHash() => r'21017a412ccde9c802cc6d88eeba0a4504bf982c';

final class ListaHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ListaEntry>>,
          (String, {DateTime? startDate, DateTime? endDate})
        > {
  ListaHistoryFamily._()
    : super(
        retry: null,
        name: r'listaHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListaHistoryProvider call(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) => ListaHistoryProvider._(
    argument: (storeId, startDate: startDate, endDate: endDate),
    from: this,
  );

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
    required (String, {DateTime? startDate, DateTime? endDate}) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ListaEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ListaEntry>> create(Ref ref) {
    final argument =
        this.argument as (String, {DateTime? startDate, DateTime? endDate});
    return publicListaHistory(
      ref,
      argument.$1,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
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
    r'7fa3dcb8b111d6b2f2a8cc5cbd28fc4e7ac9c754';

final class PublicListaHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ListaEntry>>,
          (String, {DateTime? startDate, DateTime? endDate})
        > {
  PublicListaHistoryFamily._()
    : super(
        retry: null,
        name: r'publicListaHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PublicListaHistoryProvider call(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) => PublicListaHistoryProvider._(
    argument: (storeId, startDate: startDate, endDate: endDate),
    from: this,
  );

  @override
  String toString() => r'publicListaHistoryProvider';
}
