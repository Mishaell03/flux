import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/post.dart';

class SessionBootstrapResult {
  final bool isSessionNeedUpdate;

  const SessionBootstrapResult({
    required this.isSessionNeedUpdate,
  });

  factory SessionBootstrapResult.fromJson(Map<String, dynamic> json) {
    return SessionBootstrapResult(
      isSessionNeedUpdate: json['is_session_need_update'] == true,
    );
  }
}

class SessionRefreshResult {
  final String token;

  const SessionRefreshResult({
    required this.token,
  });

  factory SessionRefreshResult.fromJson(Map<String, dynamic> json) {
    return SessionRefreshResult(
      token: json['token']?.toString() ?? '',
    );
  }
}

class SessionBootstrapService {
  const SessionBootstrapService();

  Future<SessionBootstrapResult> bootstrap({
    required String token,
  }) async {
    final response = await PostJsonService.request(
      url: ApiConfig.sessionBootstrap,
      token: token,
      data: const {},
    );

    return SessionBootstrapResult.fromJson(response);
  }

  Future<SessionRefreshResult> refresh({
    required String token,
  }) async {
    final response = await PostJsonService.request(
      url: ApiConfig.sessionRefresh,
      token: token,
      data: const {},
    );

    return SessionRefreshResult.fromJson(response);
  }
}
