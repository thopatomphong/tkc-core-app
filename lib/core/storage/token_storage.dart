import 'dart:convert';

import 'package:core_app/models/auth_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Abstracts secure key/value storage so tests can inject an in-memory map.
abstract interface class _KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class _SecureStore implements _KeyValueStore {
  const _SecureStore(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);
  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class _MemoryStore implements _KeyValueStore {
  _MemoryStore(this._map);
  final Map<String, String> _map;

  @override
  Future<String?> read(String key) async => _map[key];
  @override
  Future<void> write(String key, String value) async => _map[key] = value;
  @override
  Future<void> delete(String key) async => _map.remove(key);
}

class TokenStorage {
  TokenStorage._(this._store);

  factory TokenStorage() =>
      TokenStorage._(const _SecureStore(FlutterSecureStorage()));

  /// Test-only constructor backed by an in-memory map.
  factory TokenStorage.forTesting(Map<String, String> backing) =>
      TokenStorage._(_MemoryStore(backing));

  final _KeyValueStore _store;

  static const _tokensKey = 'auth_tokens';
  static const _deviceIdKey = 'device_id';

  Future<void> saveTokens(AuthTokens tokens) =>
      _store.write(_tokensKey, jsonEncode(tokens.toJson()));

  Future<AuthTokens?> readTokens() async {
    final raw = await _store.read(_tokensKey);
    if (raw == null) return null;
    return AuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearTokens() => _store.delete(_tokensKey);

  Future<String> getOrCreateDeviceId() async {
    final existing = await _store.read(_deviceIdKey);
    if (existing != null) return existing;
    final created = const Uuid().v4();
    await _store.write(_deviceIdKey, created);
    return created;
  }
}
