import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/get.dart';
import 'package:front/core/api/request/post.dart';
import 'package:front/core/sync/models/note_link_sync.dart';

class NoteLinksApiService {
  const NoteLinksApiService();

  Future<List<NoteLinkSyncItem>> getAll({
    required String token,
  }) async {
    final response = await GetService.request(
      url: ApiConfig.noteLinks,
      token: token,
    );

    final rawLinks = response['links'];

    if (rawLinks is! List) return [];

    return rawLinks
        .whereType<Map>()
        .map((item) => NoteLinkSyncItem.fromJson(
      Map<String, dynamic>.from(item),
    ))
        .toList();
  }

  Future<void> pushForNote({
    required String token,
    required String fromNoteId,
    required List<NoteLinkSyncItem> links,
  }) async {
    await PostJsonService.request(
      url: ApiConfig.noteLinksPush,
      token: token,
      data: {
        'from_note_id': fromNoteId,
        'links': links.map((link) {
          return {
            'to_note_id': link.toNoteId,
            'weight': link.weight,
          };
        }).toList(),
      },
    );
  }
}