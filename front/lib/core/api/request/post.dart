import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/response.dart';
import 'package:front/core/errors/app_exception.dart';

class PostJsonService {
  static Future<Map<String, dynamic>> request({
    required String url,
    required Map<String, dynamic> data,
    String? token,
    String? error,
  }) async {
    final uri = Uri.parse(url);

    final encodedBody = jsonEncode(data);

    try {
      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: encodedBody,
      )
          .timeout(ApiConfig.timeout);

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