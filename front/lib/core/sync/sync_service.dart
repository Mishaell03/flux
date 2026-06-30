import 'package:front/core/components/secure/auth_token_storage.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/sync/models/note_link_sync.dart';
import 'package:front/core/sync/services/note_links_api_service.dart';
import 'package:front/core/sync/services/sync_api_service.dart';
import 'package:front/core/sync/services/sync_local_service.dart';

class SyncService {
  final SyncApiService api;
  final NoteLinksApiService noteLinksApi;
  final SyncLocalService local;

  bool _isSyncing = false;

  SyncService({
    SyncApiService? api,
    NoteLinksApiService? noteLinksApi,
    SyncLocalService? local,
  })  : api = api ?? const SyncApiService(),
        noteLinksApi = noteLinksApi ?? const NoteLinksApiService(),
        local = local ?? SyncLocalService();

  Future<void> sync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      final token = await AuthTokenStorage.read();

      if (token == null || token.trim().isEmpty) {
        throw const AppException(code: AppErrorCode.errorProfileFailed);
      }

      // 1. STATUS CHECK
      final noteVersions = await local.getNoteVersions();
      final reminderVersions = await local.getReminderVersions();

      final status = await api.getStatus(
        token: token,
        notes: noteVersions,
        reminders: reminderVersions,
      );

      // 2. PULL UPDATES FROM SERVER
      if (status.noteIdsToPull.isNotEmpty ||
          status.reminderIdsToPull.isNotEmpty) {
        final pullResponse = await api.pull(
          token: token,
          noteIds: status.noteIdsToPull,
          reminderIds: status.reminderIdsToPull,
        );

        await local.applyPulledNotes(pullResponse.notes);
        await local.applyPulledReminders(pullResponse.reminders);
      }

      // 3. PUSH CLIENT UPDATES TO SERVER
      final notesToPush = await local.getDirtyNotesPayloadByIds(
        status.noteIdsToPush,
      );

      final remindersToPush = await local.getDirtyRemindersPayloadByIds(
        status.reminderIdsToPush,
      );

      final noteLinksToPush = <String, List<NoteLinkSyncItem>>{};

      for (final note in notesToPush) {
        final noteId = note['id']?.toString();

        if (noteId == null || noteId.isEmpty) continue;

        noteLinksToPush[noteId] = await local.buildLinksFromNote(
          fromNoteId: noteId,
          content: note['content']?.toString() ?? '',
        );
      }

      if (notesToPush.isNotEmpty || remindersToPush.isNotEmpty) {
        final pushResponse = await api.push(
          token: token,
          notes: notesToPush,
          reminders: remindersToPush,
        );

        await local.markNotesSynced(pushResponse.syncedNoteIds);
        await local.markRemindersSynced(pushResponse.syncedReminderIds);
      }

      // 4. GRAPH SYNC
      for (final entry in noteLinksToPush.entries) {
        await noteLinksApi.pushForNote(
          token: token,
          fromNoteId: entry.key,
          links: entry.value,
        );
      }

      // 5. REFRESH GLOBAL LINKS
      final links = await noteLinksApi.getAll(token: token);
      await local.replaceNoteLinks(links);
    } finally {
      _isSyncing = false;
    }
  }
}
