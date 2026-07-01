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

  /// No description provided for @profileSyncSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get profileSyncSynced;

  /// No description provided for @profileSyncPending.
  ///
  /// In en, this message translates to:
  /// **'Local changes are waiting for sync'**
  String get profileSyncPending;

  /// No description provided for @profileSyncPendingShort.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get profileSyncPendingShort;

  /// No description provided for @profileSyncAction.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get profileSyncAction;

  /// No description provided for @profileSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get profileSyncing;

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

  /// No description provided for @profileRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetry;

  /// No description provided for @profileLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get profileLoginAgain;

  /// No description provided for @profileNoData.
  ///
  /// In en, this message translates to:
  /// **'No profile data'**
  String get profileNoData;

  /// No description provided for @profileRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get profileRefresh;

  /// No description provided for @profileSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get profileSessionsTitle;

  /// No description provided for @profileSessionsRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get profileSessionsRefreshTooltip;

  /// No description provided for @profileSessionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load sessions'**
  String get profileSessionsLoadError;

  /// No description provided for @profileSessionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get profileSessionsEmpty;

  /// No description provided for @profileSessionCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get profileSessionCurrent;

  /// No description provided for @profileSessionDeviceFallback.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get profileSessionDeviceFallback;

  /// No description provided for @profileSessionRevokeTooltip.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get profileSessionRevokeTooltip;

  /// No description provided for @profileSessionRevokeError.
  ///
  /// In en, this message translates to:
  /// **'Could not end session'**
  String get profileSessionRevokeError;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @navGraph.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get navGraph;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeSearch.
  ///
  /// In en, this message translates to:
  /// **'Search notes or reminders'**
  String get homeSearch;

  /// No description provided for @homeUpcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'Upcoming reminders'**
  String get homeUpcomingReminders;

  /// No description provided for @homeNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders for this day'**
  String get homeNoReminders;

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// No description provided for @homeNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get homeNoNotes;

  /// No description provided for @homeRecentNotes.
  ///
  /// In en, this message translates to:
  /// **'Recent notes'**
  String get homeRecentNotes;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeMap.
  ///
  /// In en, this message translates to:
  /// **'Flux map'**
  String get homeMap;

  /// No description provided for @homeOpenGraph.
  ///
  /// In en, this message translates to:
  /// **'Open graph'**
  String get homeOpenGraph;

  /// No description provided for @homeLinkedNotes.
  ///
  /// In en, this message translates to:
  /// **'linked notes'**
  String get homeLinkedNotes;

  /// No description provided for @homeSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get homeSyncError;

  /// No description provided for @timeNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get timeNow;

  /// No description provided for @timeInMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {minutes}m'**
  String timeInMinutes(Object minutes);

  /// No description provided for @timeInHours.
  ///
  /// In en, this message translates to:
  /// **'in {hours}h'**
  String timeInHours(Object hours);

  /// No description provided for @timeInDays.
  ///
  /// In en, this message translates to:
  /// **'in {days}d'**
  String timeInDays(Object days);

  /// No description provided for @loadingCheckingSession.
  ///
  /// In en, this message translates to:
  /// **'Checking session'**
  String get loadingCheckingSession;

  /// No description provided for @graphTitle.
  ///
  /// In en, this message translates to:
  /// **'MapGraph'**
  String get graphTitle;

  /// No description provided for @graphStats.
  ///
  /// In en, this message translates to:
  /// **'{notesCount} notes · {edgesCount} links'**
  String graphStats(Object notesCount, Object edgesCount);

  /// No description provided for @graphEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get graphEmptyTitle;

  /// No description provided for @graphEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create notes and connect them with [[links]] or #tags.'**
  String get graphEmptySubtitle;

  /// No description provided for @notesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesPageTitle;

  /// No description provided for @notesCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get notesCreateNew;

  /// No description provided for @notesTabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTabNotes;

  /// No description provided for @notesTabReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notesTabReminders;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first note to start building your knowledge base.'**
  String get notesEmptySubtitle;

  /// No description provided for @remindersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get remindersEmptyTitle;

  /// No description provided for @remindersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a reminder and it will appear here.'**
  String get remindersEmptySubtitle;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @createNote.
  ///
  /// In en, this message translates to:
  /// **'Create note'**
  String get createNote;

  /// No description provided for @createReminder.
  ///
  /// In en, this message translates to:
  /// **'Create reminder'**
  String get createReminder;

  /// No description provided for @noteCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get noteCreateTitle;

  /// No description provided for @reminderCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get reminderCreateTitle;

  /// No description provided for @noteTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleLabel;

  /// No description provided for @noteContentHint.
  ///
  /// In en, this message translates to:
  /// **'Write something...'**
  String get noteContentHint;

  /// No description provided for @noteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get noteCancel;

  /// No description provided for @noteHelp.
  ///
  /// In en, this message translates to:
  /// **'Here you can write a note in Markdown format.\n\n Supported:\n - **bold text**\n - `inline code\'\n - links - [[ link ]] and [[ name | link ]]\n - hashtags #love \n - quotes > text\n\n All changes are saved automatically (if you connect sync).'**
  String get noteHelp;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get noteHint;

  /// No description provided for @noteOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get noteOk;

  /// No description provided for @noteAttachmentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add attachment'**
  String get noteAttachmentTooltip;

  /// No description provided for @noteAttachmentAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get noteAttachmentAddImage;

  /// No description provided for @noteAttachmentAddImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose an image or take a photo'**
  String get noteAttachmentAddImageDescription;

  /// No description provided for @noteAttachmentRecordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record voice message'**
  String get noteAttachmentRecordAudio;

  /// No description provided for @noteAttachmentRecordAudioDescription.
  ///
  /// In en, this message translates to:
  /// **'Add audio as a voice message'**
  String get noteAttachmentRecordAudioDescription;

  /// No description provided for @viewImg.
  ///
  /// In en, this message translates to:
  /// **'View the image'**
  String get viewImg;

  /// No description provided for @listenVoice.
  ///
  /// In en, this message translates to:
  /// **'Listen to a voice message'**
  String get listenVoice;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from the gallery'**
  String get chooseGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @deleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTooltip;

  /// No description provided for @deleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get deleteNoteTitle;

  /// No description provided for @deleteNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'“{title}” will be deleted.'**
  String deleteNoteMessage(Object title);

  /// No description provided for @deleteReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder?'**
  String get deleteReminderTitle;

  /// No description provided for @deleteReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'“{title}” will no longer be a reminder.'**
  String deleteReminderMessage(Object title);

  /// No description provided for @reminderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Note title'**
  String get reminderTitleHint;

  /// No description provided for @reminderContentHint.
  ///
  /// In en, this message translates to:
  /// **'Note text'**
  String get reminderContentHint;

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

  /// No description provided for @errorInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid link'**
  String get errorInvalidLink;

  /// No description provided for @errorOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Link could not be opened'**
  String get errorOpenLink;

  /// No description provided for @errorNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation error'**
  String get errorNavigation;

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

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errorUnknown;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get searchError;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for “{query}”'**
  String searchEmpty(String query);

  /// No description provided for @noteUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get noteUntitled;
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
