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
  String get profileNamePlaceholder => 'Username';

  @override
  String get profileEmailPlaceholder => 'email@example.com';

  @override
  String get profileYandexConnected => 'Yandex account connected';

  @override
  String get profileVkConnected => 'VK account connected';

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
  String get profileSettingsAbout => 'About NexNote';

  @override
  String get profileSettingsAboutValue => 'Version';

  @override
  String get profileRetry => 'Retry';

  @override
  String get profileLoginAgain => 'Sign in again';

  @override
  String get profileNoData => 'No profile data';

  @override
  String get profileRefresh => 'Refresh';

  @override
  String get profileSessionsTitle => 'Sessions';

  @override
  String get profileSessionsRefreshTooltip => 'Refresh';

  @override
  String get profileSessionsLoadError => 'Could not load sessions';

  @override
  String get profileSessionsEmpty => 'No active sessions';

  @override
  String get profileSessionCurrent => 'Current';

  @override
  String get profileSessionDeviceFallback => 'Device';

  @override
  String get profileSessionRevokeTooltip => 'End session';

  @override
  String get profileSessionRevokeError => 'Could not end session';

  @override
  String get navHome => 'Home';

  @override
  String get navNotes => 'Notes';

  @override
  String get navGraph => 'Graph';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeSearch => 'Search notes or reminders';

  @override
  String get homeUpcomingReminders => 'Upcoming reminders';

  @override
  String get homeNoReminders => 'No reminders for this day';

  @override
  String get homeToday => 'Today';

  @override
  String get homeNoNotes => 'Пока никаких заметок';

  @override
  String get homeRecentNotes => 'Recent notes';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeMap => 'Flux map';

  @override
  String get homeOpenGraph => 'Open graph';

  @override
  String get homeLinkedNotes => 'inked notes';

  @override
  String get homeSyncError => 'Sync error';

  @override
  String get timeNow => 'now';

  @override
  String timeInMinutes(Object minutes) {
    return 'in ${minutes}m';
  }

  @override
  String timeInHours(Object hours) {
    return 'in ${hours}h';
  }

  @override
  String timeInDays(Object days) {
    return 'in ${days}d';
  }

  @override
  String get loadingCheckingSession => 'Checking session';

  @override
  String get graphTitle => 'MapGraph';

  @override
  String graphStats(Object notesCount, Object edgesCount) {
    return '$notesCount notes · $edgesCount links';
  }

  @override
  String get graphEmptyTitle => 'No notes yet';

  @override
  String get graphEmptySubtitle =>
      'Create notes and connect them with [[links]] or #tags.';

  @override
  String get notesPageTitle => 'Notes';

  @override
  String get notesCreateNew => 'Create new';

  @override
  String get notesTabNotes => 'Notes';

  @override
  String get notesTabReminders => 'Reminders';

  @override
  String get notesEmptyTitle => 'No notes yet';

  @override
  String get notesEmptySubtitle =>
      'Create your first note to start building your knowledge base.';

  @override
  String get remindersEmptyTitle => 'No reminders yet';

  @override
  String get remindersEmptySubtitle =>
      'Create a reminder and it will appear here.';

  @override
  String get createNote => 'Create note';

  @override
  String get createReminder => 'Create reminder';

  @override
  String get noteCreateTitle => 'New note';

  @override
  String get reminderCreateTitle => 'New reminder';

  @override
  String get noteTitleLabel => 'Title';

  @override
  String get noteContentHint => 'Write something...';

  @override
  String get noteCancel => 'Cancel';

  @override
  String get noteHelp =>
      'Here you can write a note in Markdown format.\n\n Supported:\n - **bold text**\n - `inline code\'\n - links - [[ link ]] and [[ name | link ]]\n - hashtags #love \n - quotes > text\n\n All changes are saved automatically (if you connect sync).';

  @override
  String get noteHint => 'Hint';

  @override
  String get noteOk => 'OK';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get deleteNoteTitle => 'Delete note?';

  @override
  String deleteNoteMessage(Object title) {
    return '“$title” will be deleted.';
  }

  @override
  String get deleteReminderTitle => 'Delete reminder?';

  @override
  String deleteReminderMessage(Object title) {
    return '“$title” will no longer be a reminder.';
  }

  @override
  String get reminderTitleHint => 'Note title';

  @override
  String get reminderContentHint => 'Note text';

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
  String get errorAuthFailed => 'Couldn\'t complete sign in';

  @override
  String get errorProfileFailed => 'Account data could not be retrieved';

  @override
  String get errorInvalidLink => 'Invalid link';

  @override
  String get errorOpenLink => 'Link could not be opened';

  @override
  String get errorNavigation => 'Navigation error';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorTimeout => 'Request timed out';

  @override
  String get errorUnknown => 'Unknown error';
}
