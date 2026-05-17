# Profile Screen Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the Profile screen to match the high-fidelity card-based mockup, featuring specialized widgets for headers, sections, and tiles.

**Architecture:** Decompose the UI into atomic widgets in `lib/features/profile/widgets/`. Each widget handles a specific part of the mockup's visual language (e.g., status badges, colored icon containers). Compose these in `ProfileScreen`.

**Tech Stack:** Flutter (Material 3), Hooks Riverpod, GoRouter.

---

### Task 1: Setup and Directory Structure

**Files:**
- Create: `lib/features/profile/widgets/.gitkeep` (temp to ensure directory exists)

- [ ] **Step 1: Create the widgets directory**
Run: `mkdir -p lib/features/profile/widgets`

- [ ] **Step 2: Commit**
```bash
git add lib/features/profile/widgets
git commit -m "chore: setup profile widgets directory"
```

---

### Task 2: Implement ProfileSection Widget

A generic container for grouping tiles into a white card with rounded corners and shadows.

**Files:**
- Create: `lib/features/profile/widgets/profile_section.dart`
- Test: `test/features/profile/widgets/profile_section_test.dart`

- [ ] **Step 1: Write the failing widget test**
```dart
import 'package:core_app/features/profile/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileSection displays label and children', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileSection(
            label: 'ACCOUNT',
            children: [Text('Child 1')],
          ),
        ),
      ),
    );
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('Child 1'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**
Run: `flutter test test/features/profile/widgets/profile_section_test.dart`
Expected: Compilation error (ProfileSection not found).

- [ ] **Step 3: Implement ProfileSection**
```dart
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    this.label,
    required this.children,
  });

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**
Run: `flutter test test/features/profile/widgets/profile_section_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**
```bash
git add lib/features/profile/widgets/profile_section.dart test/features/profile/widgets/profile_section_test.dart
git commit -m "feat: add ProfileSection widget"
```

---

### Task 3: Implement ProfileTile Widget

A single row item inside a section with a colored icon container and values.

**Files:**
- Create: `lib/features/profile/widgets/profile_tile.dart`
- Test: `test/features/profile/widgets/profile_tile_test.dart`

- [ ] **Step 1: Write the failing widget test**
```dart
import 'package:core_app/features/profile/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileTile displays title and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileTile(
            icon: Icons.person,
            iconColor: Colors.blue,
            title: 'Display Name',
            value: 'User One',
          ),
        ),
      ),
    );
    expect(find.text('Display Name'), findsOneWidget);
    expect(find.text('User One'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**
Run: `flutter test test/features/profile/widgets/profile_tile_test.dart`

- [ ] **Step 3: Implement ProfileTile**
```dart
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.value,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**
Run: `flutter test test/features/profile/widgets/profile_tile_test.dart`

- [ ] **Step 5: Commit**
```bash
git add lib/features/profile/widgets/profile_tile.dart test/features/profile/widgets/profile_tile_test.dart
git commit -m "feat: add ProfileTile widget"
```

---

### Task 4: Implement ProfileHeader Widget

Handles the large avatar, name, email, and the "Online" status badge.

**Files:**
- Create: `lib/features/profile/widgets/profile_header.dart`
- Test: `test/features/profile/widgets/profile_header_test.dart`

- [ ] **Step 1: Write the failing widget test**
```dart
import 'package:core_app/features/profile/widgets/profile_header.dart';
import 'package:core_app/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileHeader displays user info and status badge', (tester) async {
    final user = Profile(
      id: 1,
      username: 'user1',
      displayName: 'User One',
      email: 'user1@mock.com',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileHeader(user: user),
        ),
      ),
    );

    expect(find.text('User One'), findsOneWidget);
    expect(find.text('@user1'), findsOneWidget);
    expect(find.text('user1@mock.com'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('U1'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**
Run: `flutter test test/features/profile/widgets/profile_header_test.dart`

- [ ] **Step 3: Implement ProfileHeader**
```dart
import 'package:core_app/models/profile.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final Profile user;

  @override
  Widget build(BuildContext context) {
    final initials = (user.displayName ?? user.username).substring(0, 1).toUpperCase() + 
                     (user.id.toString().substring(0, 1)); // Mocking "U1" style

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFD32F2F),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName ?? user.username,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${user.username}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 8),
                SizedBox(width: 8),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**
Run: `flutter test test/features/profile/widgets/profile_header_test.dart`

- [ ] **Step 5: Commit**
```bash
git add lib/features/profile/widgets/profile_header.dart test/features/profile/widgets/profile_header_test.dart
git commit -m "feat: add ProfileHeader widget"
```

---

### Task 5: Implement SignOutButton Widget

**Files:**
- Create: `lib/features/profile/widgets/sign_out_button.dart`
- Test: `test/features/profile/widgets/sign_out_button_test.dart`

- [ ] **Step 1: Write the failing widget test**
```dart
import 'package:core_app/features/profile/widgets/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SignOutButton renders correctly and handles tap', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignOutButton(onTap: () => tapped = true),
        ),
      ),
    );
    expect(find.text('Sign Out'), findsOneWidget);
    await tester.tap(find.text('Sign Out'));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**
Run: `flutter test test/features/profile/widgets/sign_out_button_test.dart`

- [ ] **Step 3: Implement SignOutButton**
```dart
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFD32F2F),
          elevation: 0,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Sign Out',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**
Run: `flutter test test/features/profile/widgets/sign_out_button_test.dart`

- [ ] **Step 5: Commit**
```bash
git add lib/features/profile/widgets/sign_out_button.dart test/features/profile/widgets/sign_out_button_test.dart
git commit -m "feat: add SignOutButton widget"
```

---

### Task 6: Refactor ProfileScreen

Compose all the new widgets into the final screen.

**Files:**
- Modify: `lib/features/profile/profile_screen.dart`
- Test: `test/features/profile/profile_screen_test.dart` (Update existing or create)

- [ ] **Step 1: Update ProfileScreen implementation**
```dart
import 'package:core_app/features/auth/auth_controller.dart';
import 'package:core_app/features/profile/profile_providers.dart';
import 'package:core_app/features/profile/widgets/profile_header.dart';
import 'package:core_app/features/profile/widgets/profile_section.dart';
import 'package:core_app/features/profile/widgets/profile_tile.dart';
import 'package:core_app/features/profile/widgets/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F9),
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (user) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileSection(
                  children: [
                    ProfileHeader(user: user),
                  ],
                ),
                ProfileSection(
                  label: 'ACCOUNT',
                  children: [
                    ProfileTile(
                      icon: Icons.person,
                      iconColor: const Color(0xFF1E88E5),
                      title: 'Display Name',
                      value: user.displayName ?? user.username,
                    ),
                    const Divider(height: 1, indent: 64),
                    ProfileTile(
                      icon: Icons.email,
                      iconColor: const Color(0xFF43A047),
                      title: 'Email',
                      value: user.email,
                    ),
                  ],
                ),
                ProfileSection(
                  label: 'NOTIFICATIONS',
                  children: [
                    const ProfileTile(
                      icon: Icons.notifications,
                      iconColor: const Color(0xFFFFB300),
                      title: 'Push Notifications',
                      value: 'Enabled',
                    ),
                    const Divider(height: 1, indent: 64),
                    const ProfileTile(
                      icon: Icons.notifications_active,
                      iconColor: const Color(0xFF1E88E5),
                      title: 'WebSocket',
                      value: 'Connected',
                    ),
                  ],
                ),
                SignOutButton(
                  onTap: () => ref.read(authControllerProvider.notifier).logout(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run full test suite**
Run: `flutter test`

- [ ] **Step 3: Commit**
```bash
git add lib/features/profile/profile_screen.dart
git commit -m "feat: redesign ProfileScreen using custom widgets"
```
