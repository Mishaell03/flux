class LoginCallbackRequest {
  final String state;
  final String code;

  const LoginCallbackRequest({
    required this.state,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'code': code,
    };
  }
}

class LoginCallbackResponse {
  final String token;

  const LoginCallbackResponse({required this.token});

  factory LoginCallbackResponse.fromJson(Map<String, dynamic> json) {
    return LoginCallbackResponse(token: json['token'] as String);
  }
}
