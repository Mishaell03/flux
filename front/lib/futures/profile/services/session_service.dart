import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/get.dart';
import 'package:front/core/api/request/post.dart';
import 'package:front/futures/profile/models/session.dart';

class ProfileSessionService {
  const ProfileSessionService();

  Future<List<ProfileSession>> getSessions({
    required String token,
  }) async {
    final response = await GetService.request(
      url: ApiConfig.sessions,
      token: token,
    );

    return ProfileSessionsResponse.fromJson(response).sessions;
  }

  Future<void> revokeSession({
    required String token,
    required int sessionId,
  }) async {
    await PostJsonService.request(
      url: ApiConfig.revokeSession(sessionId),
      token: token,
      data: const {},
    );
  }
}
