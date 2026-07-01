import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/response.dart';
import 'package:front/core/errors/app_exception.dart';

class GetBytesService {
  static Future<Uint8List> request({
    required String url,
    String? token,
    String? error,
  }) async {
    final uri = Uri.parse(url);

    if (kDebugMode) {
      print('\n========== GET BYTES REQUEST ==========');
      print('URL: $uri');
      print('HEADERS:');
      print({
        'Accept': '*/*',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      print('======================================\n');
    }

    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': '*/*',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.timeout);

      if (kDebugMode) {
        print('\n========== GET BYTES RESPONSE ==========');
        print('STATUS: ${response.statusCode}');
        print('BYTES: ${response.bodyBytes.length}');
        if (response.statusCode < 200 || response.statusCode >= 300) {
          print('BODY: ${response.body}');
        }
        print('========================================\n');
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        ResponseHandler.request(
          response.statusCode,
          response.body,
          error,
        );
      }

      return response.bodyBytes;
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