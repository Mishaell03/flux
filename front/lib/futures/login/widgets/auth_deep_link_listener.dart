import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/futures/login/services/auth_callback.dart';
import 'package:go_router/go_router.dart';

class AuthDeepLinkListener {
  final GoRouter router;
  final AuthCallbackCompleteService callbackService;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  AuthDeepLinkListener({
    required this.router,
    required this.callbackService,
  });

  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();

      if (initialUri != null) {
        handle(initialUri);
      }
    } catch (_) {}

    _sub = _appLinks.uriLinkStream.listen(handle);
  }

  void handle(Uri uri) async {
    final state = uri.queryParameters['state'];
    final code = uri.queryParameters['code'];

    if (state == null || code == null) return;

    try {
      final data = AuthDeepLinkData(
        state: state,
        code: code,
        uri: uri,
      );

      await callbackService.complete(data);

      router.go('/profile');
    } catch (e) {
      router.go('/login');
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}