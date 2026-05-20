export 'interstitial_ad_manager_stub.dart'
    if (dart.library.js_interop) 'interstitial_ad_manager_stub.dart' // Web is currently a stub
    if (dart.library.io) 'interstitial_ad_manager_mobile.dart';
