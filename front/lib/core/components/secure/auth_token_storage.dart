import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'auth_token';

  const AuthTokenStorage._();

  static Future<void> save(String token) {
    return _storage.write(key: _key, value: token);
  }

  static Future<String?> read() {
    return _storage.read(key: _key);
  }

  static Future<void> clear() {
    return _storage.delete(key: _key);
  }
}
