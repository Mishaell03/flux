import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:front/core/components/secure/device_id.dart';

class PushTokenService {
  static const Duration _timeout = Duration(seconds: 6);
  static const String? _webVapidKey = null; // TODO: вставить ваш ключ

  static Future<String> pushToken({
    required String platform,
  }) async {
    if (_isFcmSupportedPlatform(platform)) {
      try {
        final token = await FirebaseMessaging.instance
            .getToken(vapidKey: kIsWeb ? _webVapidKey : null)
            .timeout(_timeout);

        if (token != null && token.isNotEmpty) {
          return token;
        }
      } catch (_) {
      }
    }

    final deviceId = await DeviceIdService.deviceId();

    return 'unsupported_fcm_${platform}_$deviceId';
  }

  static bool _isFcmSupportedPlatform(String platform) {
    if (kIsWeb) return true;

    return platform == 'android' ||
        platform == 'ios' ||
        platform == 'macos';
  }
}