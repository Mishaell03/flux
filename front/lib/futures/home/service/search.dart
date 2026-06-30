import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/get.dart';
import 'package:front/core/components/secure/auth_token_storage.dart';
import 'package:front/futures/home/models/search.dart';

class SearchService {
  SearchService._();

  static Future<SearchResponse> search({
    required String query,
    int limit = 20,
  }) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      return SearchResponse.empty;
    }

    final token = await AuthTokenStorage.read();

    final response = await GetService.request(
      url: ApiConfig.search,
      query: {
        'q': trimmed,
        'limit': limit,
      },
      token: token,
      error: 'search_request_error',
    );

    return SearchResponse.fromJson(response);
  }
}
