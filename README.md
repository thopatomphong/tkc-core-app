# Core App - TKC Mail Service

Runnable Flutter app for the TKC assignment. Core App provides authentication,
profile, inbox, sent mail, email detail, compose, realtime mail refresh, FCM
device registration, and a launcher that hosts the Shopping and Concert mini
apps.

## Features

- Login flow with secure token storage and authenticated API requests.
- Profile screen backed by the mock server API.
- Mail inbox, sent mail, email detail, and compose workflows.
- Socket.IO realtime refresh for mail updates.
- Firebase Cloud Messaging and local notification integration.
- Launcher shell for Shopping and Concert mini apps.

## Prerequisites

- Flutter with Dart SDK support for `^3.11.1`.
- iOS Simulator/Xcode or Android Emulator/Android Studio for device testing.
- Docker for the mock server.
- Sibling mini-app repositories when using local path dependencies:
  - `../shopping_mini_app`
  - `../concert_mini_app`

## Setup

Install Flutter dependencies:

```bash
flutter pub get
```

Start the mock server from this repository root:

```bash
docker compose up -d
```

Swagger pages:

- `http://localhost:3000/swagger`
- `http://localhost:3000/swagger/shopping`
- `http://localhost:3000/swagger/concert`

Mock users:

- `user1` / `password`
- `user2` / `password`

## Firebase

Firebase files are intentionally ignored because they are environment-specific
and may contain sensitive values. Add the required Firebase configuration before
testing push notifications:

- `lib/firebase_options.dart`
- `ios/Runner/GoogleService-Info.plist`
- `android/app/google-services.json`
- `firebase/service-account.json`

If APNs is unavailable, demo FCM push notifications on Android.

## Mini App Integration

During local development, Core uses path dependencies:

```yaml
shopping_mini_app:
  path: ../shopping_mini_app
concert_mini_app:
  path: ../concert_mini_app
```

For delivery, replace those with Git dependencies pinned to each vendor package
tag, for example `v1.0.0`.

## Run

```bash
flutter run
```

## Verify

```bash
flutter analyze
flutter test
```

## Troubleshooting

- If `flutter pub get` cannot find `shopping_mini_app` or `concert_mini_app`,
  clone those repositories next to `core_app` or switch `pubspec.yaml` to the
  delivery Git dependencies.
- If Firebase initialization fails, confirm all required Firebase config files
  exist for the platform you are running.
- If mail, profile, or auth requests fail locally, confirm the mock server is
  running with `docker compose up -d` and that `http://localhost:3000/swagger`
  is reachable.
