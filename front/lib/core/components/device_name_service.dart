import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceNameService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> deviceName() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfo.webBrowserInfo;

        final browserName = info.browserName.name;
        final platform = info.platform ?? 'web';

        return _normalize('$browserName $platform');
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final info = await _deviceInfo.androidInfo;

          final manufacturer = info.manufacturer.trim();
          final model = info.model.trim();

          if (manufacturer.isNotEmpty && model.isNotEmpty) {
            return _normalize('$manufacturer $model');
          }

          return _normalize(model.isNotEmpty ? model : 'Android device');

        case TargetPlatform.iOS:
          final info = await _deviceInfo.iosInfo;

          final name = info.name.trim();
          final model = info.model.trim();

          if (name.isNotEmpty) {
            return _normalize(name);
          }

          return _normalize(model.isNotEmpty ? model : 'iOS device');

        case TargetPlatform.windows:
          final info = await _deviceInfo.windowsInfo;

          final name = info.computerName.trim();

          return _normalize(name.isNotEmpty ? name : 'Windows PC');

        case TargetPlatform.macOS:
          final info = await _deviceInfo.macOsInfo;

          final name = info.computerName.trim();

          return _normalize(name.isNotEmpty ? name : 'Mac');

        case TargetPlatform.linux:
          final info = await _deviceInfo.linuxInfo;

          final name = info.prettyName.trim();

          return _normalize(name.isNotEmpty ? name : 'Linux PC');

        default:
          return 'Unknown device';
      }
    } catch (_) {
      return 'Unknown device';
    }
  }

  static String _normalize(String value) {
    var cleaned = value.trim();

    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    cleaned = cleaned.replaceAll(
      RegExp(r'''[^\w .\-()[\]/#+:,&]''', unicode: true),
      '',
    );

    if (cleaned.isEmpty) {
      return 'Unknown device';
    }

    if (cleaned.length > 32) {
      return cleaned.substring(0, 32);
    }

    return cleaned;
  }
}