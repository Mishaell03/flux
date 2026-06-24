import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/post.dart';
import 'package:front/core/sync/models/sync_pull.dart';
import 'package:front/core/sync/models/sync_push.dart';
import 'package:front/core/sync/models/sync_status.dart';

class SyncApiService {
  const SyncApiService();

  Future<SyncStatusResponse> getStatus({
    required String token,
    required List<SyncEntityVersion> notes,
    required List<SyncEntityVersion> reminders,
  }) async {
    final response = await PostJsonService.request(
      url: ApiConfig.syncStatus,
      token: token,
      data: {
        'notes': notes.map((item) => item.toJson()).toList(),
        'reminders': reminders.map((item) => item.toJson()).toList(),
      },
    );

    return SyncStatusResponse.fromJson(response);
  }

  Future<SyncPushResponse> push({
    required String token,
    required List<Map<String, dynamic>> notes,
    required List<Map<String, dynamic>> reminders,
  }) async {
    final response = await PostJsonService.request(
      url: ApiConfig.syncPush,
      token: token,
      data: {
        'notes': notes,
        'reminders': reminders,
      },
    );

    return SyncPushResponse.fromJson(response);
  }

  Future<SyncPullResponse> pull({
    required String token,
    required Set<String> noteIds,
    required Set<String> reminderIds,
  }) async {
    final response = await PostJsonService.request(
      url: ApiConfig.syncPull,
      token: token,
      data: {
        'notes': noteIds.toList(),
        'reminders': reminderIds.toList(),
      },
    );

    return SyncPullResponse.fromJson(response);
  }
}