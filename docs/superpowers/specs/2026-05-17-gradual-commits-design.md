# Design Spec: Gradual Commit of TKC Core App

**Date:** 2026-05-17
**Topic:** Gradual Commits

## Goal
Stage and commit existing changes (modified and untracked files) in a logical, feature-based sequence of 6 commits to facilitate code review and maintain a clean history.

## Commit Plan

### 1. Foundation & Infrastructure
**Intent:** Establish the project configuration, app entry points, and core networking/storage utilities.
- **Files:**
  - `README.md` (modified)
  - `pubspec.yaml` (modified)
  - `pubspec.lock` (modified)
  - `android/app/src/main/AndroidManifest.xml` (modified)
  - `ios/Flutter/Debug.xcconfig` (modified)
  - `ios/Flutter/Release.xcconfig` (modified)
  - `ios/Podfile` (untracked)
  - `lib/main.dart` (modified)
  - `lib/app.dart` (untracked)
  - `lib/core/router/app_router.dart` (untracked)
  - `lib/core/network/auth_interceptor.dart` (modified)
  - `lib/core/storage/token_storage.dart` (modified)
  - `test/core/network/auth_interceptor_test.dart` (modified)

### 2. Realtime & Notification Services
**Intent:** Add communication infrastructure for websockets and push notifications.
- **Files:**
  - `lib/notifications/fcm_service.dart` (untracked)
  - `lib/notifications/local_notifications.dart` (untracked)
  - `lib/realtime/websocket_providers.dart` (untracked)
  - `lib/realtime/websocket_service.dart` (untracked)
  - `test/notifications/fcm_service_test.dart` (untracked)

### 3. Authentication Feature
**Intent:** Add UI and logic for user authentication.
- **Files:**
  - `lib/features/auth/auth_controller.dart` (untracked)
  - `lib/features/auth/login_screen.dart` (untracked)
  - `test/features/auth/auth_controller_test.dart` (untracked)

### 4. Profile Feature
**Intent:** Add user profile management and display.
- **Files:**
  - `lib/features/profile/profile_providers.dart` (untracked)
  - `lib/features/profile/profile_repository.dart` (untracked)
  - `lib/features/profile/profile_screen.dart` (untracked)
  - `test/features/profile/profile_repository_test.dart` (untracked)

### 5. Mail Feature
**Intent:** Add email inbox, detail view, and composition features.
- **Files:**
  - `lib/features/mail/compose_screen.dart` (untracked)
  - `lib/features/mail/email_detail_screen.dart` (untracked)
  - `lib/features/mail/inbox_screen.dart` (untracked)
  - `lib/features/mail/mail_providers.dart` (untracked)
  - `lib/features/mail/mail_repository.dart` (untracked)
  - `test/features/mail/mail_repository_test.dart` (untracked)

### 6. Launcher & Mini-App Integration
**Intent:** Add the main launcher screen and the host implementations for integrated mini-apps.
- **Files:**
  - `lib/features/launcher/launcher_screen.dart` (untracked)
  - `lib/features/launcher/post_login_effects.dart` (untracked)
  - `lib/integration/concert_host_impl.dart` (untracked)
  - `lib/integration/shopping_host_impl.dart` (untracked)

## Verification
- Run `flutter analyze` after each commit (or at the end) to ensure no regressions.
- Run `flutter test` to verify all tests pass.
