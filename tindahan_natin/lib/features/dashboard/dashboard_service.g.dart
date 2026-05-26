// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardService)
final dashboardServiceProvider = DashboardServiceProvider._();

final class DashboardServiceProvider
    extends
        $FunctionalProvider<
          DashboardService,
          DashboardService,
          DashboardService
        >
    with $Provider<DashboardService> {
  DashboardServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardServiceHash();

  @$internal
  @override
  $ProviderElement<DashboardService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardService create(Ref ref) {
    return dashboardService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardService>(value),
    );
  }
}

String _$dashboardServiceHash() => r'aff18f630e84f6d6c7b54e4886ed68bd2603e84c';

@ProviderFor(storeStats)
final storeStatsProvider = StoreStatsFamily._();

final class StoreStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<StoreStats>,
          StoreStats,
          FutureOr<StoreStats>
        >
    with $FutureModifier<StoreStats>, $FutureProvider<StoreStats> {
  StoreStatsProvider._({
    required StoreStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'storeStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storeStatsHash();

  @override
  String toString() {
    return r'storeStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StoreStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StoreStats> create(Ref ref) {
    final argument = this.argument as String;
    return storeStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storeStatsHash() => r'c5bbd10c04b87ae8c54e3d91fcd4239581ac5d40';

final class StoreStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StoreStats>, String> {
  StoreStatsFamily._()
    : super(
        retry: null,
        name: r'storeStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoreStatsProvider call(String storeId) =>
      StoreStatsProvider._(argument: storeId, from: this);

  @override
  String toString() => r'storeStatsProvider';
}
