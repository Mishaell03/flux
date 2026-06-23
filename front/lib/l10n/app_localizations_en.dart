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
  String get authCallbackWaitingTitle => 'Waiting for confirmation';

  @override
  String get authCallbackSendingTitle => 'Completing sign in';

  @override
  String get authCallbackSuccessTitle => 'Done';

  @override
  String get authCallbackErrorTitle => 'Could not sign in';

  @override
  String get authCallbackWaitingDescription =>
      'Complete authorization in the browser. After returning to the app, sign in will continue automatically.';

  @override
  String get authCallbackSendingDescription =>
      'Checking authorization data. Please wait.';

  @override
  String get authCallbackSuccessDescription => 'Signed in successfully.';

  @override
  String get authCallbackBack => 'Go back';

  @override
  String get authCallbackRetry => 'Open authorization again';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileNamePlaceholder => 'Username';

  @override
  String get profileEmailPlaceholder => 'email@example.com';

  @override
  String get profileYandexConnected => 'Yandex account connected';

  @override
  String get profileSyncStatus => 'Sync status';

  @override
  String get profileSyncUpToDate => 'All changes are up to date';

  @override
  String get profileSyncLocal => 'Local';

  @override
  String get profileSyncCloud => 'Cloud';

  @override
  String get profileSyncLastSync => 'Last sync';

  @override
  String get profileSyncSynced => 'Synced';

  @override
  String get profileSyncLastSyncValue => 'Today';

  @override
  String get profileStatNotes => 'Notes';

  @override
  String get profileStatReminders => 'Reminders';

  @override
  String get profileStatLinked => 'Linked notes';

  @override
  String get profileSettingsTheme => 'Theme';

  @override
  String get profileSettingsThemeValue => 'Light';

  @override
  String get profileSettingsNotifications => 'Notifications';

  @override
  String get profileSettingsNotificationsValue => 'On';

  @override
  String get profileSettingsDevices => 'Devices';

  @override
  String get profileSettingsDevicesValue => '3 connected';

  @override
  String get profileSettingsAbout => 'About NexNote';

  @override
  String get profileSettingsAboutValue => 'Version 1.0.0';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get sectionDevelopment =>
      'This section is currently under development';

  @override
  String get weApologize => 'We apologize';

  @override
  String get errorCouldNotOpenLink => 'Couldn\'t open the link';

  @override
  String get errorServerUnavailable => 'Server is unavailable';

  @override
  String get errorNetworkUnavailable => 'No internet connection';

  @override
  String get errorAuthFailed => 'Couldn\'t complete sign in';
}
