# Core App - TKC Mail Service

Runnable Flutter app for the TKC assignment. It provides authentication,
profile, inbox, email detail, compose, realtime mail refresh, FCM device
registration, and a launcher that hosts the Shopping and Concert mini apps.

## Mock server

From the workspace root:

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

`firebase_options.dart`, platform Firebase files, and
`firebase/service-account.json` are intentionally ignored. Add your Firebase
configuration before testing push notifications. If APNs is unavailable, demo
FCM push on Android.

## Mini app integration

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
flutter pub get
flutter run
```

## Verify

```bash
flutter analyze
flutter test
```
