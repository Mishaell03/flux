class ProfileSession {
  final int id;
  final String deviceId;
  final String? deviceName;
  final String? platform;
  final String? appVersion;
  final String? provider;
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime expiresAt;

  const ProfileSession({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.appVersion,
    required this.provider,
    required this.isCurrent,
    required this.createdAt,
    required this.expiresAt,
  });

  factory ProfileSession.fromJson(Map<String, dynamic> json) {
    return ProfileSession(
      id: json['id'] as int,
      deviceId: json['device_id']?.toString() ?? '',
      deviceName: json['device_name']?.toString(),
      platform: json['platform']?.toString(),
      appVersion: json['app_version']?.toString(),
      provider: json['provider']?.toString(),
      isCurrent: json['is_current'] == true,
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
      expiresAt: DateTime.parse(json['expires_at'].toString()).toLocal(),
    );
  }
}

class ProfileSessionsResponse {
  final List<ProfileSession> sessions;

  const ProfileSessionsResponse({
    required this.sessions,
  });

  factory ProfileSessionsResponse.fromJson(Map<String, dynamic> json) {
    final rawSessions = json['sessions'];

    if (rawSessions is! List) {
      return const ProfileSessionsResponse(sessions: []);
    }

    return ProfileSessionsResponse(
      sessions: rawSessions
          .whereType<Map>()
          .map((item) => ProfileSession.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(),
    );
  }
}
