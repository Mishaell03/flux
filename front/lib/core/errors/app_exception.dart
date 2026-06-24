import 'package:flutter/material.dart';
import 'package:front/l10n/app_localizations.dart';

enum AppErrorCode {
  timeout,
  networkError,
  unknown,
  errorProfileFailed,
}

class AppException implements Exception {
  final AppErrorCode code;
  final String? message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.code,
    this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException(code: $code, message: $message)';
  }
}

extension AppErrorCodeX on AppErrorCode {
  String localizedMessage(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    switch (this) {
      case AppErrorCode.timeout:
        return t.errorTimeout;

      case AppErrorCode.networkError:
        return t.errorNetwork;

      case AppErrorCode.unknown:
        return t.errorUnknown;

      case AppErrorCode.errorProfileFailed:
        return t.errorProfileFailed;
    }
  }
}