// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interstitial_ad_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interstitialAd)
final interstitialAdProvider = InterstitialAdProvider._();

final class InterstitialAdProvider
    extends
        $FunctionalProvider<
          InterstitialAdManager,
          InterstitialAdManager,
          InterstitialAdManager
        >
    with $Provider<InterstitialAdManager> {
  InterstitialAdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interstitialAdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interstitialAdHash();

  @$internal
  @override
  $ProviderElement<InterstitialAdManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterstitialAdManager create(Ref ref) {
    return interstitialAd(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterstitialAdManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterstitialAdManager>(value),
    );
  }
}

String _$interstitialAdHash() => r'07391264c101a7fe7f2496a888dd395b5c3c0d1f';
