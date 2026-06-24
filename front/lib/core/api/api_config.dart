class ApiConfig {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';
  // static const String _baseUrl = 'http://10.0.0.252:8000/api/v1';

  static const String yandexLogin = '$_baseUrl/auth/yandex/login';
  static const String yandexCallback = '$_baseUrl/auth/yandex/callback';

  static const String userProfile = '$_baseUrl/user/me';

  static const timeout = Duration(seconds: 30);
  static const timeoutConnect = Duration(seconds: 10);
  static const uploadTimeout = Duration(minutes: 2);
}
