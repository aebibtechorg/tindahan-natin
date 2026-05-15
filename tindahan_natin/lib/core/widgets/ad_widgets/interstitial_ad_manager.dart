import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tindahan_natin/core/config/ad_config/ad_helper.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  final Duration _adDebounceTime = const Duration(minutes: 5);
  DateTime? _lastAdShowTime;

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
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
          _interstitialAd = null;
        },
      ),
    );
  }

  void showAd() {
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
