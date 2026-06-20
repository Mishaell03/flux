import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/response.dart';
import 'package:front/core/errors/api_exception.dart';
import 'package:front/core/errors/app_exception.dart';

class GetService {
  static Future<Map<String, dynamic>> request({
    required String url,
    Map<String, dynamic>? query,
    String? token,
    String? error,
  }) async {
    try {
      final uri = Uri.parse(url).replace(
        queryParameters: query == null
            ? null
            : {
                for (final entry in query.entries)
                  if (entry.value != null) entry.key: entry.value.toString(),
              },
      );

      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.timeout);

      return ResponseHandler.request(response.statusCode, response.body, error);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const AppException(code: AppErrorCode.timeout);
    } on SocketException {
      throw const AppException(code: AppErrorCode.networkError);
    } catch (error, stackTrace) {
      throw AppException(
        code: AppErrorCode.unknown,
        originalError: error,
        stackTrace: stackTrace,
      );
    }
  }
}
