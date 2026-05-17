# Gradual Commits Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stage and commit existing project changes in 6 logical, feature-grouped commits.

**Architecture:** Feature-based grouping of untracked and modified files.

**Tech Stack:** Git, Flutter (Dart).

---

### Task 1: Foundation & Infrastructure

**Files:**
- Modify: `README.md`
- Modify: `pubspec.yaml`
- Modify: `pubspec.lock`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `ios/Flutter/Debug.xcconfig`
- Modify: `ios/Flutter/Release.xcconfig`
- Create: `ios/Podfile`
- Modify: `lib/main.dart`
- Create: `lib/app.dart`
- Create: `lib/core/router/app_router.dart`
- Modify: `lib/core/network/auth_interceptor.dart`
- Modify: `lib/core/storage/token_storage.dart`
- Modify: `test/core/network/auth_interceptor_test.dart`

- [ ] **Step 1: Stage foundation files**

Run: `git add README.md pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml ios/Flutter/Debug.xcconfig ios/Flutter/Release.xcconfig ios/Podfile lib/main.dart lib/app.dart lib/core/router/app_router.dart lib/core/network/auth_interceptor.dart lib/core/storage/token_storage.dart test/core/network/auth_interceptor_test.dart`

- [ ] **Step 2: Verify analysis and tests**

Run: `flutter analyze && flutter test test/core/`
Expected: PASS

- [ ] **Step 3: Commit foundation**

Run: `git commit -m "feat: add project foundation and core infrastructure"`

---

### Task 2: Realtime & Notification Services

**Files:**
- Create: `lib/notifications/fcm_service.dart`
- Create: `lib/notifications/local_notifications.dart`
- Create: `lib/realtime/websocket_providers.dart`
- Create: `lib/realtime/websocket_service.dart`
- Test: `test/notifications/fcm_service_test.dart`

- [ ] **Step 1: Stage service files**

Run: `git add lib/notifications/ lib/realtime/ test/notifications/fcm_service_test.dart`

- [ ] **Step 2: Verify tests**

Run: `flutter test test/notifications/fcm_service_test.dart`
Expected: PASS

- [ ] **Step 3: Commit services**

Run: `git commit -m "feat: add realtime and notification services"`

---

### Task 3: Authentication Feature

**Files:**
- Create: `lib/features/auth/auth_controller.dart`
- Create: `lib/features/auth/login_screen.dart`
- Test: `test/features/auth/auth_controller_test.dart`

- [ ] **Step 1: Stage auth files**

Run: `git add lib/features/auth/auth_controller.dart lib/features/auth/login_screen.dart test/features/auth/auth_controller_test.dart`

- [ ] **Step 2: Verify tests**

Run: `flutter test test/features/auth/auth_controller_test.dart`
Expected: PASS

- [ ] **Step 3: Commit auth**

Run: `git commit -m "feat: add authentication UI and controller"`

---

### Task 4: Profile Feature

**Files:**
- Create: `lib/features/profile/profile_providers.dart`
- Create: `lib/features/profile/profile_repository.dart`
- Create: `lib/features/profile/profile_screen.dart`
- Test: `test/features/profile/profile_repository_test.dart`

- [ ] **Step 1: Stage profile files**

Run: `git add lib/features/profile/ test/features/profile/profile_repository_test.dart`

- [ ] **Step 2: Verify tests**

Run: `flutter test test/features/profile/profile_repository_test.dart`
Expected: PASS

- [ ] **Step 3: Commit profile**

Run: `git commit -m "feat: add profile feature"`

---

### Task 5: Mail Feature

**Files:**
- Create: `lib/features/mail/compose_screen.dart`
- Create: `lib/features/mail/email_detail_screen.dart`
- Create: `lib/features/mail/inbox_screen.dart`
- Create: `lib/features/mail/mail_providers.dart`
- Create: `lib/features/mail/mail_repository.dart`
- Test: `test/features/mail/mail_repository_test.dart`

- [ ] **Step 1: Stage mail files**

Run: `git add lib/features/mail/ test/features/mail/mail_repository_test.dart`

- [ ] **Step 2: Verify tests**

Run: `flutter test test/features/mail/mail_repository_test.dart`
Expected: PASS

- [ ] **Step 3: Commit mail**

Run: `git commit -m "feat: add mail feature"`

---

### Task 6: Launcher & Mini-App Integration

**Files:**
- Create: `lib/features/launcher/launcher_screen.dart`
- Create: `lib/features/launcher/post_login_effects.dart`
- Create: `lib/integration/concert_host_impl.dart`
- Create: `lib/integration/shopping_host_impl.dart`

- [ ] **Step 1: Stage launcher and integration files**

Run: `git add lib/features/launcher/ lib/integration/`

- [ ] **Step 2: Verify final state**

Run: `flutter analyze && flutter test`
Expected: PASS

- [ ] **Step 3: Commit launcher**

Run: `git commit -m "feat: add launcher and mini-app integration"`
