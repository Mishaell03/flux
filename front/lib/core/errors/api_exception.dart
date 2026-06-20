class ApiException implements Exception {
  final int statusCode;
  final String? backendCode;
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const ApiException({
    required this.statusCode,
    this.backendCode,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, backendCode: $backendCode, message: $message)';
  }
}
