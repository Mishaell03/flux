import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:front/core/components/secure/auth_token_storage.dart';
import 'package:front/core/errors/api_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/router/url_launcher.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/futures/login/services/auth_callback.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AuthDeepLinkService {
  final AuthDeepLinkParser parser;

  AuthDeepLinkService(this.parser);

  Future<String> handle(Uri uri) async {
    final data = parser.parse(uri);

    if (data == null) {
      throw const AppException(code: AppErrorCode.unknown);
    }

    final response = await LoginCallbackService.send(
      state: data.state,
      code: data.code,
    );

    await AuthTokenStorage.save(response.token);

    return response.token;
  }
}

class AuthDeepLinkParser {
  const AuthDeepLinkParser();

  AuthDeepLinkData? parse(Uri uri) {
    if (!_isLoginProfileLink(uri)) return null;

    final state = uri.queryParameters['state'];
    final code = uri.queryParameters['code'];

    if (state == null || state.isEmpty || code == null || code.isEmpty) {
      return null;
    }

    return AuthDeepLinkData(uri: uri, state: state, code: code);
  }

  bool _isLoginProfileLink(Uri uri) {
    return uri.scheme == 'flux' &&
        uri.host == 'login' &&
        uri.path == '/profile';
  }
}

class AuthDeepLinkEventBus {
  AuthDeepLinkEventBus._();

  static final AuthDeepLinkEventBus instance = AuthDeepLinkEventBus._();

  final StreamController<AuthDeepLinkData> _controller =
      StreamController<AuthDeepLinkData>.broadcast();

  String? _lastEmittedLink;
  AuthDeepLinkData? _pendingData;

  Stream<AuthDeepLinkData> get stream => _controller.stream;

  void emit(AuthDeepLinkData data) {
    if (_lastEmittedLink == data.key) return;

    _lastEmittedLink = data.key;
    _pendingData = data;

    _controller.add(data);
  }

  AuthDeepLinkData? takePending() {
    final data = _pendingData;
    _pendingData = null;
    return data;
  }
}

class AuthExternalAuthService {
  const AuthExternalAuthService();

  Future<bool> open(String authUrl) {
    return UrlLauncher.openExternalUrl(authUrl);
  }
}

// Листенер живёт на уровне роутера — context недоступен напрямую,
// поэтому передаём navigatorKey чтобы показывать AppNotice
class AuthDeepLinkListener {
  final GoRouter router;
  final AuthCallbackCompleteService callbackService;
  final GlobalKey<NavigatorState> navigatorKey;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  AuthDeepLinkListener({
    required this.router,
    required this.callbackService,
    required this.navigatorKey,
  });

  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) handle(initialUri);
    } catch (_) {}

    _sub = _appLinks.uriLinkStream.listen(handle);
  }

  void handle(Uri uri) async {
    final state = uri.queryParameters['state'];
    final code = uri.queryParameters['code'];

    if (state == null || code == null) return;

    final context = navigatorKey.currentContext;

    try {
      final data = AuthDeepLinkData(state: state, code: code, uri: uri);

      await callbackService.complete(data);

      router.go('/profile');
    } on ApiException catch (e) {
      if (context != null && context.mounted) {
        AppNotice.error(context, message: e.message);
      }
      router.go('/login');
    } on AppException catch (e) {
      if (context != null && context.mounted) {
        AppNotice.error(
          context,
          message: e.code.localizedMessage(context),
        );
      }

      router.go('/login');
    } catch (_) {
      if (context != null && context.mounted) {
        final t = AppLocalizations.of(context)!;
        AppNotice.error(context, message: t.errorAuthFailed);
      }
      router.go('/login');
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
