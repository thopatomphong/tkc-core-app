# Home Screen Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the application's entry point to a high-fidelity Home Screen with a modern tabbed navigation structure (Home, Mail, Profile).

**Architecture:** Use `go_router`'s `StatefulShellRoute` to manage navigation between Home, Mail, and Profile branches. `LauncherScreen` will act as the shell hosting the `BottomNavigationBar`.

**Tech Stack:** Flutter, Riverpod, GoRouter, Hooks.

---

### Task 1: Refactor Router to StatefulShellRoute

**Files:**
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Update app_router.dart to use StatefulShellRoute**

```dart
// lib/core/router/app_router.dart

// ... existing imports ...
import 'package:core_app/features/launcher/home_screen.dart'; // Will be created in Task 2

// ... existing code ...

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home', // Changed from '/'
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final isLogin = state.matchedLocation == '/login';
      return auth.maybeWhen(
        data: (loggedIn) {
          if (!loggedIn) return isLogin ? null : '/login';
          if (isLogin) return '/home'; // Changed from '/'
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
                    path: ':id',
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
      // Move other standalone routes if needed, but for now they are nested in branches
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "refactor: update router to use StatefulShellRoute"
```

### Task 2: Create HomeScreen and Placeholder Widgets

**Files:**
- Create: `lib/features/launcher/home_screen.dart`
- Create: `lib/features/launcher/widgets/home_header.dart`
- Create: `lib/features/launcher/widgets/mini_app_card.dart`

- [ ] **Step 1: Create HomeHeader widget**

```dart
// lib/features/launcher/widgets/home_header.dart
import 'package:core_app/features/profile/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, required this.onAvatarTap});

  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good morning,',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              profile.when(
                data: (user) => Text(
                  user.displayName ?? user.username,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                loading: () => const Text('...'),
                error: (_, __) => const Text('User'),
              ),
            ],
          ),
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFD32F2F),
              child: profile.when(
                data: (user) => Text(
                  (user.displayName ?? user.username).substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                orElse: () => const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Create MiniAppCard widget**

```dart
// lib/features/launcher/widgets/mini_app_card.dart
import 'package:flutter/material.dart';

class MiniAppCard extends StatelessWidget {
  const MiniAppCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Create HomeScreen widget**

```dart
// lib/features/launcher/home_screen.dart
import 'package:core_app/features/launcher/widgets/home_header.dart';
import 'package:core_app/features/launcher/widgets/mini_app_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onProfileRequested});

  final VoidCallback? onProfileRequested;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(onAvatarTap: () => onProfileRequested?.call()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Mini Apps',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  MiniAppCard(
                    title: 'Shopping',
                    description: 'Browse & order products',
                    icon: Icons.shopping_bag_outlined,
                    iconColor: const Color(0xFF1E88E5),
                    onTap: () => context.go('/shopping'),
                  ),
                  MiniAppCard(
                    title: 'Concert',
                    description: 'Book concert tickets',
                    icon: Icons.confirmation_num_outlined,
                    iconColor: const Color(0xFFFFB300),
                    onTap: () => context.go('/concert'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/launcher/home_screen.dart lib/features/launcher/widgets/
git commit -m "feat: add HomeScreen and its components"
```

### Task 3: Refactor LauncherScreen to be the Shell

**Files:**
- Modify: `lib/features/launcher/launcher_screen.dart`

- [ ] **Step 1: Refactor LauncherScreen to use StatefulNavigationShell**

```dart
// lib/features/launcher/launcher_screen.dart
import 'package:core_app/features/launcher/post_login_effects.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LauncherScreen extends ConsumerWidget {
  const LauncherScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(postLoginEffectsProvider);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            selectedIcon: Icon(Icons.mail),
            label: 'Mail',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Update HomeScreen to handle profile navigation**

```dart
// lib/features/launcher/home_screen.dart
// Update build method to use the navigation shell if available or just go to /profile
// Since it's a branch, we should use navigationShell.goBranch(2) or context.go('/profile')
```

Actually, `HomeScreen` can just call `context.go('/profile')` and `go_router` will handle the branch switch if configured correctly.

- [ ] **Step 3: Commit**

```bash
git add lib/features/launcher/launcher_screen.dart
git commit -m "refactor: update LauncherScreen to be the navigation shell"
```

### Task 4: Testing and Verification

**Files:**
- Create: `test/features/launcher/home_screen_test.dart`

- [ ] **Step 1: Write widget tests for HomeScreen**

```dart
// test/features/launcher/home_screen_test.dart
// ... tests for greeting, mini app cards, navigation ...
```

- [ ] **Step 2: Run tests**

Run: `flutter test test/features/launcher/home_screen_test.dart`
Expected: PASS

- [ ] **Step 3: Analyze and Format**

Run: `dart analyze && dart format .`
Expected: No issues

- [ ] **Step 4: Commit**

```bash
git add test/features/launcher/home_screen_test.dart
git commit -m "test: add widget tests for HomeScreen"
```
