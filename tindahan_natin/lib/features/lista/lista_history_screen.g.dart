// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_history_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ListaDateRange)
final listaDateRangeProvider = ListaDateRangeProvider._();

final class ListaDateRangeProvider
    extends $NotifierProvider<ListaDateRange, DateTimeRange<DateTime>?> {
  ListaDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listaDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listaDateRangeHash();

  @$internal
  @override
  ListaDateRange create() => ListaDateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>?>(value),
    );
  }
}

String _$listaDateRangeHash() => r'0898a2bee23a861716128842d59b6239b79784a4';

abstract class _$ListaDateRange extends $Notifier<DateTimeRange<DateTime>?> {
  DateTimeRange<DateTime>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<DateTimeRange<DateTime>?, DateTimeRange<DateTime>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTimeRange<DateTime>?, DateTimeRange<DateTime>?>,
              DateTimeRange<DateTime>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
