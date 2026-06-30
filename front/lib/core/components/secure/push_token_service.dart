import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:front/core/components/secure/device_id.dart';

class PushTokenService {
  static Future<String> pushToken({
    required String platform,
  }) async {
    if (_isFcmSupportedPlatform(platform)) {
      final token = await FirebaseMessaging.instance.getToken();

      if (token != null && token.isNotEmpty) {
        return token;
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