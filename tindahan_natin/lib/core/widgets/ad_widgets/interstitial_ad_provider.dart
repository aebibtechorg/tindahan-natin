import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tindahan_natin/core/config/ad_config/ad_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interstitial_ad_provider.g.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  final Duration _adDebounceTime = const Duration(minutes: 10); // increased to 10 mins for better UX
  DateTime? _lastAdShowTime;
  bool _isLoading = false;

  InterstitialAdManager() {
    _loadAd();
  }

  void _loadAd() {
    if (_isLoading || _interstitialAd != null) return;
    _isLoading = true;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  void showAdIfReady() {
    final now = DateTime.now();
    if (_lastAdShowTime == null || now.difference(_lastAdShowTime!) > _adDebounceTime) {
      if (_interstitialAd != null) {
        _interstitialAd!.show();
        _lastAdShowTime = now;
      } else {
        _loadAd();
      }
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}

@riverpod
InterstitialAdManager interstitialAd(Ref ref) {
  final manager = InterstitialAdManager();
  ref.onDispose(() => manager.dispose());
  return manager;
}
