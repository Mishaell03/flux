import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  const UrlLauncher._();

  static Future<bool> openExternalUrl(String url) async {
    final Uri? uri = Uri.tryParse(url);

    if (uri == null) {
      debugPrint('UrlLauncher: неккоректная ссылка: $url');
      return false;
    }

    if (!uri.hasScheme) {
      debugPrint('UrlLauncher: у ссылки нет схемы: $url');
      return false;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (opened) {
        return true;
      }

      return _openWithPlatformFallback(uri);
    } catch (error) {
      debugPrint('UrlLauncher: ссылка $url \nошибка: $error');
      return _openWithPlatformFallback(uri);
    }
  }

  static Future<bool> _openWithPlatformFallback(Uri uri) async {
    if (kIsWeb || !Platform.isWindows) {
      return false;
    }

    try {
      final result = await Process.run(
        'rundll32',
        [
          'url.dll,FileProtocolHandler',
          uri.toString(),
        ],
      );

      if (result.exitCode == 0) {
        return true;
      }

      debugPrint(
        'UrlLauncher: Windows fallback failed: ${result.stderr}',
      );
    } catch (error) {
      debugPrint('UrlLauncher: Windows fallback error: $error');
    }

    return false;
  }
}
