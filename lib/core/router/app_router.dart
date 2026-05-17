import 'package:core_app/features/auth/auth_controller.dart';
import 'package:core_app/features/auth/login_screen.dart';
import 'package:core_app/features/launcher/home_screen.dart';
import 'package:core_app/features/launcher/launcher_screen.dart';
import 'package:core_app/features/mail/presentation/screens/compose_screen.dart';
import 'package:core_app/features/mail/presentation/screens/email_detail_screen.dart';
import 'package:core_app/features/mail/presentation/screens/inbox_screen.dart';
import 'package:core_app/features/profile/profile_screen.dart';
import 'package:core_app/integration/concert_host_impl.dart';
import 'package:core_app/integration/shopping_host_impl.dart';
import 'package:concert_mini_app/concert_mini_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_mini_app/shopping_mini_app.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final isLogin = state.matchedLocation == '/login';
      return auth.maybeWhen(
        data: (loggedIn) {
          if (!loggedIn) return isLogin ? null : '/login';
          if (isLogin) return '/home';
          return null;
        },
        orElse: () => null,
      );
    },
    routes: <RouteBase>[
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LauncherScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mail',
                builder: (context, state) => const InboxScreen(),
                routes: [
                  GoRoute(
                    path: 'mail/:id',
                    builder: (context, state) => EmailDetailScreen(
                      emailId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/compose',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ComposeScreen(),
      ),
      GoRoute(
        path: '/shopping',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            ShoppingMiniApp.create(host: ShoppingHostImpl(ref, context)),
      ),
      GoRoute(
        path: '/concert',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            ConcertMiniApp.create(host: ConcertHostImpl(ref, context)),
      ),
    ],
  );
});
