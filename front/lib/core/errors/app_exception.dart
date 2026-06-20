enum AppErrorCode {
  timeout,
  networkError,
  unknown,
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
