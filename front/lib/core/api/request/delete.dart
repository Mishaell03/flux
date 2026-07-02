import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/response.dart';
import 'package:front/core/errors/app_exception.dart';

class DeleteService {
  static Future<Map<String, dynamic>> request({
    required String url,
    String? token,
    String? error,
  }) async {
    final uri = Uri.parse(url);

    if (kDebugMode) {
      print('\n========== DELETE REQUEST ==========');
      print('URL: $uri');
      print('HEADERS:');
      print({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      print('===================================\n');
    }

    try {
      final response = await http
          .delete(
            uri,
            headers: {
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.timeout);

      if (kDebugMode) {
        print('\n========== DELETE RESPONSE ==========');
        print('STATUS: ${response.statusCode}');
        print('BODY: ${response.body}');
        print('=====================================\n');
      }

      return ResponseHandler.request(
        response.statusCode,
        response.body,
        error,
      );
    } on TimeoutException {
      throw const AppException(code: AppErrorCode.timeout);
    } on SocketException {
      throw const AppException(code: AppErrorCode.networkError);
    } on http.ClientException catch (e, st) {
      throw AppException(
        code: AppErrorCode.networkError,
        originalError: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppException(
        code: AppErrorCode.unknown,
        originalError: e,
        stackTrace: st,
      );
    }
  }
}