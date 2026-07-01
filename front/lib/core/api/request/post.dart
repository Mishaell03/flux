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

    // 1. ЛОГ ЗАПРОСА (ключевой)
    if (kDebugMode) {
      print('\n========== POST REQUEST ==========');
      print('URL: $uri');
      print('HEADERS:');
      print({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      print('BODY RAW MAP: $data');
      print('BODY ENCODED JSON: $encodedBody');
      print('=================================\n');
    }

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

      // 2. ЛОГ ОТВЕТА
      if (kDebugMode) {
        print('\n========== RESPONSE ==========');
        print('STATUS: ${response.statusCode}');
        print('BODY: ${response.body}');
        print('==============================\n');
      }

      // 3. ВАЖНО: если 422 — сразу печатаем detail
      if (response.statusCode == 422) {
        print('\n❌ VALIDATION ERROR (422)');
        print(response.body);
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

class PostMultipartService {
  static Future<Map<String, dynamic>> request({
    required String url,
    required Map<String, String> fields,
    required Uint8List fileBytes,
    required String fileField,
    required String fileName,
    String? token,
    String? error,
  }) async {
    final uri = Uri.parse(url);

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    request.fields.addAll(fields);

    request.files.add(
      http.MultipartFile.fromBytes(
        fileField,
        fileBytes,
        filename: fileName,
      ),
    );

    if (kDebugMode) {
      print('\n========== MULTIPART POST REQUEST ==========');
      print('URL: $uri');
      print('HEADERS:');
      print(request.headers);
      print('FIELDS: $fields');
      print('FILE FIELD: $fileField');
      print('FILE NAME: $fileName');
      print('FILE BYTES: ${fileBytes.length}');
      print('===========================================\n');
    }

    try {
      final streamed = await request.send().timeout(ApiConfig.timeout);
      final response =
          await http.Response.fromStream(streamed).timeout(ApiConfig.timeout);

      if (kDebugMode) {
        print('\n========== MULTIPART RESPONSE ==========');
        print('STATUS: ${response.statusCode}');
        print('BODY: ${response.body}');
        print('========================================\n');
      }

      if (response.statusCode == 422) {
        print('\n❌ MULTIPART VALIDATION ERROR (422)');
        print(response.body);
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