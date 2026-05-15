import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tindahan_natin/core/config/ad_initializer.dart';
import 'package:tindahan_natin/core/config/app_logger.dart';
import 'package:tindahan_natin/core/routing/app_router.dart';
import 'package:tindahan_natin/core/sync/sync_coordinator.dart';
import 'package:tindahan_natin/core/theme/app_theme.dart';

void main() async {
  try {
    debugPrint('Starting Tindahan Natin...');
    WidgetsFlutterBinding.ensureInitialized();

    debugPrint('Initializing Ads...');
    unawaited(initializeAds());
    
    debugPrint('Initializing Hive...');
    await Hive.initFlutter();
    
    debugPrint('Opening Hive boxes...');
    await Hive.openBox('settings');
    await Hive.openBox('products_cache');
    await Hive.openBox('entity_cache');
    await Hive.openBox('pending_mutations');
    
    debugPrint('Running App...');
    runApp(
      ProviderScope(
        observers: [AppLogger()],
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    debugPrint('FATAL ERROR DURING STARTUP: $e');
    debugPrint(stack.toString());
    // Show a minimal error app if possible
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to start app: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    ref.watch(syncCoordinatorProvider);

    return MaterialApp.router(
      title: 'Tindahan Natin',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}