import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kIsWeb) {
      return const String.fromEnvironment(
        'BANNER_AD_UNIT_ID_WEB',
        defaultValue: "ca-app-pub-3940256099942544/6300978111",
      );
    }
    
    // For non-web platforms, we use the environment directly or default values.
    // Note: On web, Platform.isAndroid would throw.
    const androidId = String.fromEnvironment(
      'BANNER_AD_UNIT_ID_ANDROID',
      defaultValue: "ca-app-pub-3940256099942544/6300978111",
    );
    const iosId = String.fromEnvironment(
      'BANNER_AD_UNIT_ID_IOS',
      defaultValue: "ca-app-pub-3940256099942544/2934735716",
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosId;
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
    
    const androidId = String.fromEnvironment(
      'INTERSTITIAL_AD_UNIT_ID_ANDROID',
      defaultValue: "ca-app-pub-3940256099942544/1033173712",
    );
    const iosId = String.fromEnvironment(
      'INTERSTITIAL_AD_UNIT_ID_IOS',
      defaultValue: "ca-app-pub-3940256099942544/4411468910",
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosId;
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
    
    const androidId = String.fromEnvironment(
      'NATIVE_AD_UNIT_ID_ANDROID',
      defaultValue: "ca-app-pub-3940256099942544/2247696110",
    );
    const iosId = String.fromEnvironment(
      'NATIVE_AD_UNIT_ID_IOS',
      defaultValue: "ca-app-pub-3940256099942544/3986624511",
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
