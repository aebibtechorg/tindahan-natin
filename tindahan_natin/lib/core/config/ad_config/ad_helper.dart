import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kIsWeb) {
      return const String.fromEnvironment(
        'BANNER_AD_UNIT_ID_WEB',
        defaultValue: "ca-app-pub-3940256099942544/6300978111",
      );
    }
    if (Platform.isAndroid) {
      return const String.fromEnvironment(
        'BANNER_AD_UNIT_ID_ANDROID',
        defaultValue: "ca-app-pub-3940256099942544/6300978111",
      );
    } else if (Platform.isIOS) {
      return const String.fromEnvironment(
        'BANNER_AD_UNIT_ID_IOS',
        defaultValue: "ca-app-pub-3940256099942544/2934735716",
      );
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) {
      return const String.fromEnvironment(
        'INTERSTITIAL_AD_UNIT_ID_WEB',
        defaultValue: "ca-app-pub-3940256099942544/1033173712",
      );
    }
    if (Platform.isAndroid) {
      return const String.fromEnvironment(
        'INTERSTITIAL_AD_UNIT_ID_ANDROID',
        defaultValue: "ca-app-pub-3940256099942544/1033173712",
      );
    } else if (Platform.isIOS) {
      return const String.fromEnvironment(
        'INTERSTITIAL_AD_UNIT_ID_IOS',
        defaultValue: "ca-app-pub-3940256099942544/4411468910",
      );
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (kIsWeb) {
      return const String.fromEnvironment(
        'NATIVE_AD_UNIT_ID_WEB',
        defaultValue: "ca-app-pub-3940256099942544/2247696110",
      );
    }
    if (Platform.isAndroid) {
      return const String.fromEnvironment(
        'NATIVE_AD_UNIT_ID_ANDROID',
        defaultValue: "ca-app-pub-3940256099942544/2247696110",
      );
    } else if (Platform.isIOS) {
      return const String.fromEnvironment(
        'NATIVE_AD_UNIT_ID_IOS',
        defaultValue: "ca-app-pub-3940256099942544/3986624511",
      );
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
