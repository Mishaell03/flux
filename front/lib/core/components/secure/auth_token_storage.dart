import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/core/errors/app_exception.dart';

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


class AuthTokenWaiter {
  const AuthTokenWaiter._();

  static Future<String> wait({
    Duration timeout = const Duration(seconds: 3),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final startedAt = DateTime.now();

    while (DateTime.now().difference(startedAt) < timeout) {
      final token = await AuthTokenStorage.read();
      final normalized = token?.trim();

      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }

      await Future.delayed(interval);
    }

    throw const AppException(
      code: AppErrorCode.errorProfileFailed,
    );
  }
}