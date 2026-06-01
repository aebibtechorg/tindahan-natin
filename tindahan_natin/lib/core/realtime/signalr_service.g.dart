// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signalr_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RealtimeClient)
final realtimeClientProvider = RealtimeClientProvider._();

final class RealtimeClientProvider
    extends $NotifierProvider<RealtimeClient, void> {
  RealtimeClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeClientHash();

  @$internal
  @override
  RealtimeClient create() => RealtimeClient();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$realtimeClientHash() => r'80ae1fca838e7702e3483ad8ca0cf263b6caabb4';

abstract class _$RealtimeClient extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
