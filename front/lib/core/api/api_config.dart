class ApiConfig {
  static const String _baseUrl = 'https://flux.pipipopi.online:8000/api/v1'; // production
  // static const String _baseUrl = 'http://10.10.0.2:8000/api/v1';  // web

  // static const String _baseUrl = 'http://127.0.0.1:8000/api/v1'; // local

  static const String yandexLogin = '$_baseUrl/auth/yandex/login';
  static const String yandexCallback = '$_baseUrl/auth/yandex/callback';

  static const String userProfile = '$_baseUrl/user/me';
  static const String sessions = '$_baseUrl/session/active';
  static const String sessionBootstrap = '$_baseUrl/session/bootstrap';
  static const String sessionRefresh = '$_baseUrl/session/refresh';

  static String revokeSession(int sessionId) {
    return '$_baseUrl/session/$sessionId/revoke';
  }

  static const String syncPush = '$_baseUrl/sync/push';
  static const String syncStatus = '$_baseUrl/sync/status';
  static const String syncPull = '$_baseUrl/sync/pull';

  static const String noteLinks = '$_baseUrl/note-links';
  static const String noteLinksPush = '$_baseUrl/note-links/push';

  static const timeout = Duration(seconds: 30);
  static const timeoutConnect = Duration(seconds: 10);
  static const uploadTimeout = Duration(minutes: 2);
}
