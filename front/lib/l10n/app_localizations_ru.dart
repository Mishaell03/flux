// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Flux';

  @override
  String get loginWelcome =>
      'Добро пожаловать обратно! Пожалуйста, войдите в систему, чтобы продолжить';

  @override
  String get loginCreateAccount => 'Создать или войти в аккаунт';

  @override
  String get loginChooseService =>
      'Выберите предпочитаемый вами сервис для входа';

  @override
  String get loginContinueYou => 'Продолжая, вы соглашаетесь с нашими\n';

  @override
  String get loginTermsOfService => 'условия обслуживания';

  @override
  String get loginAnd => ' и ';

  @override
  String get loginPrivacyPolicy => 'политика конфиденциальности';

  @override
  String get loginWithYandex => 'Продолжить с Яндекс';

  @override
  String get loginWithVk => 'Продолжить с ВКонтакте';

  @override
  String get success => 'Успешно';

  @override
  String get error => 'Ошибка';

  @override
  String get errorCouldNotOpenLink => 'Не удалось открыть ссылку';
}
