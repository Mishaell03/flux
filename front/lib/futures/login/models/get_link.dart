class GetLinkRequest {
  final String deviceId;
  final String platform;
  final String language;
  final String appVersion;
  final String deviceName;

  const GetLinkRequest({
    required this.deviceId,
    required this.platform,
    required this.language,
    required this.appVersion,
    required this.deviceName,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'platform': platform,
      'language': language,
      'app_version': appVersion,
      'device_name': deviceName,
    };
  }
}

class GetLinkResponse {
  final String url;

  const GetLinkResponse({required this.url});

  factory GetLinkResponse.fromJson(Map<String, dynamic> json) {
    return GetLinkResponse(url: json['url'] as String);
  }
}
