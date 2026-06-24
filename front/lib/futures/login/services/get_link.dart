import 'package:front/core/api/request/post.dart';
import 'package:front/core/components/secure/app_version_service.dart';
import 'package:front/core/components/secure/device_id.dart';
import 'package:front/core/components/secure/device_name_service.dart';
import 'package:front/futures/login/models/get_link.dart';

class GetLinkService {
  static Future<GetLinkResponse> getLink({
    required String platform,
    required String language,
    required String url,
  }) async {
    final deviceId = await DeviceIdService.deviceId();
    final appVersion = await AppVersionService.appVersion();
    final deviceName = await DeviceNameService.deviceName();

    final request = GetLinkRequest(
      deviceId: deviceId,
      platform: platform,
      language: language,
      appVersion: appVersion,
      deviceName: deviceName,
    );

    final response = await PostJsonService.request(
      url: url,
      data: request.toJson(),
    );

    return GetLinkResponse.fromJson(response);
  }
}