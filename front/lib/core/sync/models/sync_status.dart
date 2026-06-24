class SyncEntityVersion {
  final String id;
  final DateTime updatedAt;

  const SyncEntityVersion({
    required this.id,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }
}

class SyncStatusItem {
  final String id;
  final bool isUpdateRequired;
  final bool serverHasLatestVersion;

  const SyncStatusItem({
    required this.id,
    required this.isUpdateRequired,
    required this.serverHasLatestVersion,
  });

  factory SyncStatusItem.fromJson(Map<String, dynamic> json) {
    return SyncStatusItem(
      id: json['id'].toString(),
      isUpdateRequired: json['is_update_required'] == true,
      serverHasLatestVersion: json['server_has_latest_version'] == true,
    );
  }

  bool get shouldPushToServer {
    return isUpdateRequired && !serverHasLatestVersion;
  }

  bool get shouldPullFromServer {
    return isUpdateRequired && serverHasLatestVersion;
  }
}

class SyncStatusResponse {
  final List<SyncStatusItem> notes;
  final List<SyncStatusItem> reminders;

  const SyncStatusResponse({
    required this.notes,
    required this.reminders,
  });

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) {
    return SyncStatusResponse(
      notes: _itemsFromJson(json['notes']),
      reminders: _itemsFromJson(json['reminders']),
    );
  }

  static List<SyncStatusItem> _itemsFromJson(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => SyncStatusItem.fromJson(
      Map<String, dynamic>.from(item),
    ))
        .toList();
  }

  Set<String> get noteIdsToPush {
    return notes
        .where((item) => item.shouldPushToServer)
        .map((item) => item.id)
        .toSet();
  }

  Set<String> get reminderIdsToPush {
    return reminders
        .where((item) => item.shouldPushToServer)
        .map((item) => item.id)
        .toSet();
  }

  Set<String> get noteIdsToPull {
    return notes
        .where((item) => item.shouldPullFromServer)
        .map((item) => item.id)
        .toSet();
  }

  Set<String> get reminderIdsToPull {
    return reminders
        .where((item) => item.shouldPullFromServer)
        .map((item) => item.id)
        .toSet();
  }
}