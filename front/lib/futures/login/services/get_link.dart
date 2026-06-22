import 'package:front/core/api/request/post.dart';
import 'package:front/core/components/device_id.dart';
import 'package:front/futures/login/models/get_link.dart';

class GetLinkService {
  static Future<GetLinkResponse> getLink({
    required String platform,
    required String language,
    required String url,
  }) async {
    final deviceId = await DeviceIdService.deviceId();

    final request = GetLinkRequest(
      deviceId: deviceId,
      platform: platform,
      language: language,
    );

    final response =
        await PostJsonService.request(url: url, data: request.toJson());

    return GetLinkResponse.fromJson(response);
  }
}
