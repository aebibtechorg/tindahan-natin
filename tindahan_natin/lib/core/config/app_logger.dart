import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

base class AppLogger extends ProviderObserver {
  static final Logger _log = Logger('App');

  static void initialize() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
      if (record.error != null) {
        debugPrint('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        debugPrint('StackTrace:\n${record.stackTrace}');
      }
    });

    _log.info('Logger initialized');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _log.fine('Provider ${context.provider.name ?? context.provider.runtimeType} updated');
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    _log.fine('Provider ${context.provider.name ?? context.provider.runtimeType} added');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _log.severe(
      'Provider ${context.provider.name ?? context.provider.runtimeType} failed',
      error,
      stackTrace,
    );
  }
}