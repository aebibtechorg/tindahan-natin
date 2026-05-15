export 'ad_config/ad_initializer_stub.dart'
    if (dart.library.js_interop) 'ad_config/ad_initializer_web.dart'
    if (dart.library.io) 'ad_config/ad_initializer_mobile.dart';
