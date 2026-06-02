import 'url_strategy_native.dart'
    if (dart.library.js_util) 'url_strategy_web.dart'
    if (dart.library.html) 'url_strategy_web.dart';

void setUrlStrategy() {
  configureUrlStrategy();
}
