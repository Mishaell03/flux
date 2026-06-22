import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/post.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/futures/login/models/yandex_callback.dart';
import 'package:front/core/components/auth_token_storage.dart';
import 'package:front/l10n/app_localizations.dart';

class LoginCallbackService {
  const LoginCallbackService._();

  static Future<LoginCallbackResponse> send({
    required String state,
    required String code,
  }) async {
    final request = LoginCallbackRequest(
      state: state,
      code: code,
    );

    final response = await PostJsonService.request(
      url: ApiConfig.yandexCallbackUrl,
      data: request.toJson(),
    );

    return LoginCallbackResponse.fromJson(response);
  }
}


class AuthCallbackCompleteService {
  const AuthCallbackCompleteService();

  Future<void> complete(AuthDeepLinkData data) async {
    final response = await LoginCallbackService.send(
      state: data.state,
      code: data.code,
    );

    await AuthTokenStorage.save(response.token);
  }
}

class AuthCallbackErrorMapper {
  const AuthCallbackErrorMapper();

  String fromAppException(
      AppException error,
      AppLocalizations t,
      ) {
    return switch (error.code) {
      AppErrorCode.timeout => t.errorServerUnavailable,
      AppErrorCode.networkError => t.errorNetworkUnavailable,
      AppErrorCode.unknown => error.message ?? t.errorAuthFailed,
    };
  }
}