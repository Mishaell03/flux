import 'package:package_info_plus/package_info_plus.dart';

class AppVersionService {
  static Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();

    final version = info.version.trim();

    if (version.isEmpty) {
      return '0.0.0';
    }

    return _normalize(version);
  }

  static String _normalize(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^a-zA-Z0-9.]'), '');

    if (cleaned.isEmpty) {
      return '0.0.0';
    }

    if (cleaned.length > 32) {
      return cleaned.substring(0, 32);
    }

    return cleaned;
  }
}