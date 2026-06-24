import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/response.dart';
import 'package:front/core/errors/api_exception.dart';
import 'package:front/core/errors/app_exception.dart';

class PostJsonService {
  static Future<Map<String, dynamic>> request({
    required String url,
    required Map<String, dynamic> data,
    String? token,
    String? error,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          )
          .timeout(ApiConfig.timeout);

      return ResponseHandler.request(response.statusCode, response.body, error);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const AppException(code: AppErrorCode.timeout);
    } on SocketException {
      throw const AppException(code: AppErrorCode.networkError);
    } on http.ClientException catch (error, stackTrace) {
      throw AppException(
        code: AppErrorCode.networkError,
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppException(
        code: AppErrorCode.unknown,
        originalError: error,
        stackTrace: stackTrace,
      );
    }
  }
}

// class PostUploadFile {
//   final String fieldName;
//   final String path;
//
//   const PostUploadFile({
//     required this.fieldName,
//     required this.path,
//   });
// }
//
// class PostFormDataService {
//   static Future<Map<String, dynamic>> request({
//     required String url,
//     Map<String, dynamic> data = const {},
//     List<PostUploadFile> files = const [],
//     String? token,
//     String? error,
//   }) async {
//     try {
//       final uri = Uri.parse(url);
//       final request = http.MultipartRequest('POST', uri);
//
//       request.headers.addAll({
//         'Accept': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       });
//
//       data.forEach((key, value) {
//         if (value != null) {
//           request.fields[key] = value.toString();
//         }
//       });
//
//       for (final file in files) {
//         request.files.add(
//           await http.MultipartFile.fromPath(file.fieldName, file.path),
//         );
//       }
//
//       final response = await request.send().timeout(ApiConfig.uploadTimeout);
//       final responseBody = await response.stream
//           .bytesToString()
//           .timeout(ApiConfig.timeout);
//
//       return ResponseHandler.request(response.statusCode, responseBody, error);
//     } on ApiException {
//       rethrow;
//     } on TimeoutException {
//       throw const AppException(code: AppErrorCode.timeout);
//     } on SocketException {
//       throw const AppException(code: AppErrorCode.networkError);
//     } on http.ClientException catch (error, stackTrace) {
//       throw AppException(
//         code: AppErrorCode.networkError,
//         originalError: error,
//         stackTrace: stackTrace,
//       );
//     } catch (error, stackTrace) {
//       throw AppException(
//         code: AppErrorCode.unknown,
//         originalError: error,
//         stackTrace: stackTrace,
//       );
//     }
//   }
// }
