import 'dart:convert';

import 'package:front/core/errors/api_exception.dart';

class ResponseHandler {
  static Map<String, dynamic> request(
    int statusCode,
    String body,
    String? defaultError,
  ) {
    final dynamic responseData;

    try {
      responseData = body.isEmpty ? <String, dynamic>{} : jsonDecode(body);
    } on FormatException catch (error, stackTrace) {
      throw ApiException(
        statusCode: statusCode,
        message: defaultError ?? 'Invalid server response',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (statusCode >= 200 && statusCode < 300) {
      if (responseData is Map<String, dynamic>) {
        return responseData;
      }

      throw ApiException(
        statusCode: statusCode,
        message: defaultError ?? 'Invalid server response',
        originalError: responseData,
      );
    }

    final errorData = _extractMessage(
      statusCode,
      responseData,
      defaultError,
    );

    throw ApiException(
      statusCode: statusCode,
      backendCode: errorData.backendCode,
      message: errorData.message,
      originalError: responseData,
    );
  }

  static _ParsedApiError _extractMessage(
    int statusCode,
    dynamic responseData,
    String? defaultError,
  ) {
    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];

      if (detail is List && detail.isNotEmpty) {
        final firstError = detail.first;

        if (firstError is Map<String, dynamic>) {
          final message = firstError['msg'];

          return _ParsedApiError(
            message: message is String && message.trim().isNotEmpty
                ? message
                : defaultError ?? 'Validation error',
          );
        }

        return _ParsedApiError(
          message: defaultError ?? 'Validation error',
        );
      }

      if (detail is Map<String, dynamic>) {
        final backendCode = detail['code'];
        final backendMessage = detail['message'];

        final message =
            backendMessage is String && backendMessage.trim().isNotEmpty
                ? backendMessage
                : defaultError ?? 'Server error';

        return _ParsedApiError(
          backendCode: backendCode is String ? backendCode : null,
          message: message,
        );
      }

      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return _ParsedApiError(message: message);
      }

      final error = responseData['error'];
      if (error is String && error.trim().isNotEmpty) {
        return _ParsedApiError(message: error);
      }
    }

    return _ParsedApiError(
      message: defaultError ?? 'Server error',
    );
  }
}

class _ParsedApiError {
  final String? backendCode;
  final String message;

  const _ParsedApiError({
    this.backendCode,
    required this.message,
  });
}
