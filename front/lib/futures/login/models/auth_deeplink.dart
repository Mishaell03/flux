class AuthDeepLinkData {
  final Uri uri;
  final String state;
  final String code;

  const AuthDeepLinkData({
    required this.uri,
    required this.state,
    required this.code,
  });

  String get key => uri.toString();
}

enum AuthCallbackWaitingStatus {
  waitingForReturn,
  sendingCallback,
  success,
  error,
}

class AuthCallbackWaitingState {
  final AuthCallbackWaitingStatus status;
  final String? errorMessage;

  const AuthCallbackWaitingState({
    required this.status,
    this.errorMessage,
  });

  const AuthCallbackWaitingState.waiting()
      : status = AuthCallbackWaitingStatus.waitingForReturn,
        errorMessage = null;

  const AuthCallbackWaitingState.sending()
      : status = AuthCallbackWaitingStatus.sendingCallback,
        errorMessage = null;

  const AuthCallbackWaitingState.success()
      : status = AuthCallbackWaitingStatus.success,
        errorMessage = null;

  const AuthCallbackWaitingState.error([this.errorMessage])
      : status = AuthCallbackWaitingStatus.error;

  bool get canGoBack => status != AuthCallbackWaitingStatus.sendingCallback;

  bool get showLoader {
    return status == AuthCallbackWaitingStatus.waitingForReturn ||
        status == AuthCallbackWaitingStatus.sendingCallback;
  }

  bool get showRetry => status == AuthCallbackWaitingStatus.error;
}