import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/auth/login_screen.dart';
import 'package:tindahan_natin/features/dashboard/home_screen.dart';
import 'package:tindahan_natin/features/products/product_list_screen.dart';
import 'package:tindahan_natin/features/products/add_product_screen.dart';
import 'package:tindahan_natin/features/public_store/public_store_screen.dart';
import 'package:tindahan_natin/features/public_store/public_map_screen.dart';
import 'package:tindahan_natin/features/store_map/store_map_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddProductScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const StoreMapScreen(),
      ),
      GoRoute(
        path: '/store/:slug',
        builder: (context, state) => PublicStoreScreen(
          slug: state.pathParameters['slug']!,
        ),
        routes: [
          GoRoute(
            path: 'map',
            builder: (context, state) => PublicMapScreen(
              slug: state.pathParameters['slug']!,
              highlightShelfId: int.tryParse(state.uri.queryParameters['shelfId'] ?? ''),
            ),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authState.value != null;
      final matchedLocation = state.matchedLocation;
      
      // Allow public store access
      if (matchedLocation.startsWith('/store/')) return null;

      final loggingIn = matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';

      return null;
    },
  );
}