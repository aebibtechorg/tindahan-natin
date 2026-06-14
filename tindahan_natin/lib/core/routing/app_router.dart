import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/auth/login_screen.dart';
import 'package:tindahan_natin/features/dashboard/home_screen.dart';
import 'package:tindahan_natin/features/products/product_list_screen.dart';
import 'package:tindahan_natin/features/products/add_product_screen.dart';
import 'package:tindahan_natin/features/products/edit_product_screen.dart';
import 'package:tindahan_natin/features/public_store/store_lookup_screen.dart';
import 'package:tindahan_natin/features/public_store/public_store_screen.dart';
import 'package:tindahan_natin/features/public_store/public_map_screen.dart';
import 'package:tindahan_natin/features/public_store/public_store_shell.dart';
import 'package:tindahan_natin/features/store_map/store_map_screen.dart';
import 'package:tindahan_natin/features/settings/settings_screen.dart';
import 'package:tindahan_natin/features/categories/category_list_screen.dart';
import 'package:tindahan_natin/features/lista/public_lista_screen.dart';
import 'package:tindahan_natin/features/lista/add_lista_entry_screen.dart';
import 'package:tindahan_natin/features/lista/lista_history_screen.dart';
import 'package:tindahan_natin/core/widgets/app_shell.dart';
import 'package:tindahan_natin/features/onboarding/onboarding_screen.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(currentLocation: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'store',
                builder: (context, state) => const StoreLookupScreen(),
              ),
              GoRoute(
                path: 'store/:slug',
                redirect: (context, state) {
                  final slug = state.pathParameters['slug'];
                  if (slug == null) return null;
                  if (state.uri.path == '/store/$slug') {
                    return '/store/$slug/products';
                  }
                  return null;
                },
                routes: [
                  StatefulShellRoute.indexedStack(
                    builder: (context, state, navigationShell) => PublicStoreShell(
                      slug: state.pathParameters['slug']!,
                      navigationShell: navigationShell,
                    ),
                    branches: [
                      StatefulShellBranch(
                        routes: [
                          GoRoute(
                            path: 'products',
                            builder: (context, state) => PublicStoreScreen(
                              slug: state.pathParameters['slug']!,
                              onOpenMap: (shelfId) {
                                final slug = state.pathParameters['slug']!;
                                context.go('/store/$slug/map${shelfId != null ? '?shelfId=${Uri.encodeComponent(shelfId)}' : ''}');
                              },
                            ),
                          ),
                        ],
                      ),
                      StatefulShellBranch(
                        routes: [
                          GoRoute(
                            path: 'map',
                            builder: (context, state) => PublicMapScreen(
                              slug: state.pathParameters['slug']!,
                              highlightShelfId: state.uri.queryParameters['shelfId'],
                            ),
                          ),
                        ],
                      ),
                      StatefulShellBranch(
                        routes: [
                          GoRoute(
                            path: 'lista',
                            builder: (context, state) => PublicListaScreen(
                              slug: state.pathParameters['slug']!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'add',
                                builder: (context, state) => AddListaEntryScreen(
                                  slug: state.pathParameters['slug']!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const ProductListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddProductScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => EditProductScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoryListScreen(),
          ),
          GoRoute(
            path: '/lista-history',
            builder: (context, state) => const ListaHistoryScreen(),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) => const StoreMapScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'store',
                builder: (context, state) => const StoreSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final loggedIn = authState.value != null;
      final matchedLocation = state.matchedLocation;

      // Allow public store access
      if (matchedLocation == '/store' || matchedLocation.startsWith('/store/')) return null;

      final loggingIn = matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';

      // Check onboarding completion
      if (loggedIn) {
        final onboardingCompleted = ref.read(localStorageProvider).isOnboardingCompleted();
        if (!onboardingCompleted && matchedLocation != '/onboarding') {
          return '/onboarding';
        }
      }

      return null;
    },
  );
}