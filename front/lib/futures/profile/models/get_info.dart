class ProfileResponse {
  final String? name;
  final String? phone;
  final String? email;
  final String? image;

  final int notesCount;
  final int remindersCount;
  final int noteLinksCount;
  final int sessionsCount;

  final String? sessionProvider;
  final bool isVerified;

  const ProfileResponse({
    required this.name,
    required this.phone,
    required this.email,
    required this.image,
    required this.notesCount,
    required this.remindersCount,
    required this.noteLinksCount,
    required this.sessionsCount,
    required this.sessionProvider,
    required this.isVerified,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      notesCount: json['notes_count'] as int? ?? 0,
      remindersCount: json['reminders_count'] as int? ?? 0,
      noteLinksCount: json['note_links_count'] as int? ?? 0,
      sessionsCount: json['sessions_count'] as int? ?? 0,
      sessionProvider: json['session_provider'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }
}