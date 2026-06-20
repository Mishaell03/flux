// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flux';

  @override
  String get loginWelcome => 'Welcome back! Please sign in to continue';

  @override
  String get loginCreateAccount => 'Create or log in to an account';

  @override
  String get loginChooseService => 'Choose your preferred login service';

  @override
  String get loginContinueYou => 'By continuing, you agree to our\n';

  @override
  String get loginTermsOfService => 'terms of service';

  @override
  String get loginAnd => ' and ';

  @override
  String get loginPrivacyPolicy => 'privacy policy';

  @override
  String get loginWithYandex => 'Continue with Yandex';

  @override
  String get loginWithVk => 'Continue with VK';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get errorCouldNotOpenLink => 'Couldn\'t open the link';
}
