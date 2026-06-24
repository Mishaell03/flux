import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flux'**
  String get appTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in to continue'**
  String get loginWelcome;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create or log in to an account'**
  String get loginCreateAccount;

  /// No description provided for @loginChooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred login service'**
  String get loginChooseService;

  /// No description provided for @loginContinueYou.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our\n'**
  String get loginContinueYou;

  /// No description provided for @loginTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'terms of service'**
  String get loginTermsOfService;

  /// No description provided for @loginAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get loginAnd;

  /// No description provided for @loginPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get loginPrivacyPolicy;

  /// No description provided for @loginWithYandex.
  ///
  /// In en, this message translates to:
  /// **'Continue with Yandex'**
  String get loginWithYandex;

  /// No description provided for @loginWithVk.
  ///
  /// In en, this message translates to:
  /// **'Continue with VK'**
  String get loginWithVk;

  /// No description provided for @authCallbackWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for confirmation'**
  String get authCallbackWaitingTitle;

  /// No description provided for @authCallbackSendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Completing sign in'**
  String get authCallbackSendingTitle;

  /// No description provided for @authCallbackSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get authCallbackSuccessTitle;

  /// No description provided for @authCallbackErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in'**
  String get authCallbackErrorTitle;

  /// No description provided for @authCallbackWaitingDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete authorization in the browser. After returning to the app, sign in will continue automatically.'**
  String get authCallbackWaitingDescription;

  /// No description provided for @authCallbackSendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Checking authorization data. Please wait.'**
  String get authCallbackSendingDescription;

  /// No description provided for @authCallbackSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully.'**
  String get authCallbackSuccessDescription;

  /// No description provided for @authCallbackBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get authCallbackBack;

  /// No description provided for @authCallbackRetry.
  ///
  /// In en, this message translates to:
  /// **'Open authorization again'**
  String get authCallbackRetry;

  /// No description provided for @profileNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileNamePlaceholder;

  /// No description provided for @profileEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get profileEmailPlaceholder;

  /// No description provided for @profileYandexConnected.
  ///
  /// In en, this message translates to:
  /// **'Yandex account connected'**
  String get profileYandexConnected;

  /// No description provided for @profileVkConnected.
  ///
  /// In en, this message translates to:
  /// **'VK account connected'**
  String get profileVkConnected;

  /// No description provided for @profileSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get profileSyncStatus;

  /// No description provided for @profileSyncUpToDate.
  ///
  /// In en, this message translates to:
  /// **'All changes are up to date'**
  String get profileSyncUpToDate;

  /// No description provided for @profileSyncLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get profileSyncLocal;

  /// No description provided for @profileSyncCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get profileSyncCloud;

  /// No description provided for @profileSyncLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get profileSyncLastSync;

  /// No description provided for @profileSyncSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get profileSyncSynced;

  /// No description provided for @profileSyncLastSyncValue.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get profileSyncLastSyncValue;

  /// No description provided for @profileStatNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get profileStatNotes;

  /// No description provided for @profileStatReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get profileStatReminders;

  /// No description provided for @profileStatLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked notes'**
  String get profileStatLinked;

  /// No description provided for @profileSettingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileSettingsTheme;

  /// No description provided for @profileSettingsThemeValue.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileSettingsThemeValue;

  /// No description provided for @profileSettingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileSettingsNotifications;

  /// No description provided for @profileSettingsNotificationsValue.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get profileSettingsNotificationsValue;

  /// No description provided for @profileSettingsDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get profileSettingsDevices;

  /// No description provided for @profileSettingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About NexNote'**
  String get profileSettingsAbout;

  /// No description provided for @profileSettingsAboutValue.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get profileSettingsAboutValue;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @sectionDevelopment.
  ///
  /// In en, this message translates to:
  /// **'This section is currently under development'**
  String get sectionDevelopment;

  /// No description provided for @weApologize.
  ///
  /// In en, this message translates to:
  /// **'We apologize'**
  String get weApologize;

  /// No description provided for @errorCouldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get errorCouldNotOpenLink;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server is unavailable'**
  String get errorServerUnavailable;

  /// No description provided for @errorNetworkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNetworkUnavailable;

  /// No description provided for @errorAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete sign in'**
  String get errorAuthFailed;

  /// No description provided for @errorProfileFailed.
  ///
  /// In en, this message translates to:
  /// **'Account data could not be retrieved'**
  String get errorProfileFailed;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get errorTimeout;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get errorNotFound;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Invalid input data'**
  String get errorValidation;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Authorization required'**
  String get errorUnauthorized;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid server response'**
  String get errorInvalidResponse;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
