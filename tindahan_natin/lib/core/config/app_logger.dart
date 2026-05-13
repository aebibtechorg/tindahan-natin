import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class AppLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    debugPrint('Provider ${context.provider.name ?? context.provider.runtimeType} updated: $newValue');
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    debugPrint('Provider ${context.provider.name ?? context.provider.runtimeType} added');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint('Provider ${context.provider.name ?? context.provider.runtimeType} failed: $error');
  }
}