import 'package:flutter/material.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/router/url_launcher.dart';
import 'package:front/l10n/app_localizations.dart';

class LinkHandler {
  const LinkHandler._();

  static Future<void> open(
      BuildContext context,
      String href,
      ) async {
    final t = AppLocalizations.of(context)!;

    final uri = Uri.tryParse(href);

    if (uri == null) {
      AppNotice.error(
        context,
        message: '${t.errorInvalidLink}: $href',
      );
      return;
    }

    final isExternal =
        uri.hasScheme &&
            (uri.scheme == 'http' || uri.scheme == 'https');

    try {
      if (isExternal) {
        final ok = await UrlLauncher.openExternalUrl(href);

        if (!ok) {
          AppNotice.error(
            context,
            message: t.errorOpenLink,
          );
        }
      } else {
        Navigator.of(context).pushNamed(href);
      }
    } catch (e) {
      AppNotice.error(
        context,
        message: '${t.errorNavigation}: $href',
      );
    }
  }
}