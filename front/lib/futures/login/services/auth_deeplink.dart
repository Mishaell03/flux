import 'dart:async';
import 'package:front/core/router/url_launcher.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/core/components/auth_token_storage.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/futures/login/services/auth_callback.dart';

class AuthDeepLinkService {
  final AuthDeepLinkParser parser;

  AuthDeepLinkService(this.parser);

  Future<String> handle(Uri uri) async {
    final data = parser.parse(uri);

    if (data == null) {
      throw AppException(
        code: AppErrorCode.unknown,
        message: 'Invalid deep link',
      );
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

    return AuthDeepLinkData(
      uri: uri,
      state: state,
      code: code,
    );
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