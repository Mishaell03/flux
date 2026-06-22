class GetLinkRequest {
  final String deviceId;
  final String platform;
  final String language;

  const GetLinkRequest({
    required this.deviceId,
    required this.platform,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'platform': platform,
      'language': language,
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
