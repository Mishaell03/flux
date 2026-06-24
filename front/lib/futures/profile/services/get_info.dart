import 'package:front/core/api/request/get.dart';
import 'package:front/futures/profile/models/get_info.dart';

class ProfileService {
  static Future<ProfileResponse> getProfile({
    required String url,
    required String token,
  }) async {
    final response = await GetService.request(
      url: url,
      token: token,
    );

    return ProfileResponse.fromJson(response);
  }
}