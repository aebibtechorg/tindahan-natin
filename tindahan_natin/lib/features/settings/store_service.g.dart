// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveStoreId)
final activeStoreIdProvider = ActiveStoreIdProvider._();

final class ActiveStoreIdProvider
    extends $NotifierProvider<ActiveStoreId, String?> {
  ActiveStoreIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeStoreIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeStoreIdHash();

  @$internal
  @override
  ActiveStoreId create() => ActiveStoreId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeStoreIdHash() => r'3d1362d533db628becd64dff75251b43a88f4525';

abstract class _$ActiveStoreId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
