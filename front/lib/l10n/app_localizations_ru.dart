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
  String get authCallbackWaitingTitle => 'Ожидаем подтверждение';

  @override
  String get authCallbackSendingTitle => 'Завершаем вход';

  @override
  String get authCallbackSuccessTitle => 'Готово';

  @override
  String get authCallbackErrorTitle => 'Не удалось войти';

  @override
  String get authCallbackWaitingDescription =>
      'Завершите авторизацию в браузере. После возврата в приложение вход продолжится автоматически.';

  @override
  String get authCallbackSendingDescription =>
      'Проверяем данные авторизации. Пожалуйста, подождите.';

  @override
  String get authCallbackSuccessDescription => 'Вход успешно выполнен.';

  @override
  String get authCallbackBack => 'Вернуться назад';

  @override
  String get authCallbackRetry => 'Открыть авторизацию снова';

  @override
  String get profileNamePlaceholder => 'Имя пользователя';

  @override
  String get profileEmailPlaceholder => 'email@example.com';

  @override
  String get profileYandexConnected => 'Яндекс аккаунт подключён';

  @override
  String get profileVkConnected => 'Вконтакте аккаунт подключён';

  @override
  String get profileSyncStatus => 'Статус синхронизации';

  @override
  String get profileSyncUpToDate => 'Все изменения актуальны';

  @override
  String get profileSyncLocal => 'Локально';

  @override
  String get profileSyncCloud => 'Облако';

  @override
  String get profileSyncSynced => 'Синхр.';

  @override
  String get profileSyncPending => 'Локальные изменения ожидают синхронизации';

  @override
  String get profileSyncPendingShort => 'Ожидает';

  @override
  String get profileSyncAction => 'Синхронизировать';

  @override
  String get profileSyncing => 'Синхронизируем...';

  @override
  String get profileStatNotes => 'Заметки';

  @override
  String get profileStatReminders => 'Напоминания';

  @override
  String get profileStatLinked => 'Связанные';

  @override
  String get profileSettingsTheme => 'Тема';

  @override
  String get profileSettingsThemeValue => 'Светлая';

  @override
  String get profileSettingsNotifications => 'Уведомления';

  @override
  String get profileSettingsNotificationsValue => 'Вкл';

  @override
  String get profileSettingsDevices => 'Устройства';

  @override
  String get profileSettingsAbout => 'О приложении';

  @override
  String get profileSettingsAboutValue => 'Версия';

  @override
  String get profileRetry => 'Повторить';

  @override
  String get profileLoginAgain => 'Войти заново';

  @override
  String get profileNoData => 'Нет данных профиля';

  @override
  String get profileRefresh => 'Обновить';

  @override
  String get profileSessionsTitle => 'Сессии';

  @override
  String get profileSessionsRefreshTooltip => 'Обновить';

  @override
  String get profileSessionsLoadError => 'Не удалось загрузить сессии';

  @override
  String get profileSessionsEmpty => 'Активных сессий нет';

  @override
  String get profileSessionCurrent => 'Текущая';

  @override
  String get profileSessionDeviceFallback => 'Устройство';

  @override
  String get profileSessionRevokeTooltip => 'Завершить';

  @override
  String get profileSessionRevokeError => 'Не удалось завершить сессию';

  @override
  String get navHome => 'Главная';

  @override
  String get navNotes => 'Заметки';

  @override
  String get navGraph => 'Граф';

  @override
  String get navProfile => 'Профиль';

  @override
  String get homeSearch => 'Поиск заметок или напоминаний';

  @override
  String get homeUpcomingReminders => 'Предстоящие напоминания';

  @override
  String get homeNoReminders => 'Никаких напоминаний об этом дне';

  @override
  String get homeToday => 'Сегодня';

  @override
  String get homeNoNotes => 'Пока никаких заметок';

  @override
  String get homeRecentNotes => 'Последние заметки';

  @override
  String get homeSeeAll => 'Посмотреть всё';

  @override
  String get homeMap => 'Flux map';

  @override
  String get homeOpenGraph => 'Открыть граф';

  @override
  String get homeLinkedNotes => 'связей в заметках';

  @override
  String get homeSyncError => 'Ошибка синхронизации';

  @override
  String get timeNow => 'сейчас';

  @override
  String timeInMinutes(Object minutes) {
    return 'через $minutes мин';
  }

  @override
  String timeInHours(Object hours) {
    return 'через $hours ч';
  }

  @override
  String timeInDays(Object days) {
    return 'через $days дн';
  }

  @override
  String get loadingCheckingSession => 'Проверяем сессию';

  @override
  String get graphTitle => 'MapGraph';

  @override
  String graphStats(Object notesCount, Object edgesCount) {
    return '$notesCount заметок · $edgesCount связей';
  }

  @override
  String get graphEmptyTitle => 'Заметок пока нет';

  @override
  String get graphEmptySubtitle =>
      'Создай заметки и свяжи их через [[ссылки]] или #теги.';

  @override
  String get notesPageTitle => 'Заметки';

  @override
  String get notesCreateNew => 'Создать';

  @override
  String get notesTabNotes => 'Заметки';

  @override
  String get notesTabReminders => 'Напоминания';

  @override
  String get notesEmptyTitle => 'Заметок пока нет';

  @override
  String get notesEmptySubtitle =>
      'Создай первую заметку, чтобы начать собирать знания.';

  @override
  String get remindersEmptyTitle => 'Напоминаний пока нет';

  @override
  String get remindersEmptySubtitle =>
      'Создай напоминание, и оно появится здесь.';

  @override
  String get createNote => 'Создать заметку';

  @override
  String get createReminder => 'Создать напоминание';

  @override
  String get noteCreateTitle => 'Новая заметка';

  @override
  String get reminderCreateTitle => 'Новое напоминание';

  @override
  String get noteTitleLabel => 'Название';

  @override
  String get noteContentHint => 'Напиши что-нибудь...';

  @override
  String get noteCancel => 'Отмена';

  @override
  String get noteHelp =>
      'Здесь можно писать заметку в формате Markdown.\n\n Поддерживается:\n - **жирный текст**\n - `inline code`\n - ссылки - [[ link ]] и [[ name | link ]]\n - хэштеги #love \n - цитаты > текст\n\n Все изменения сохраняются автоматически после закрытия заметки';

  @override
  String get noteHint => 'Подсказка';

  @override
  String get noteOk => 'OK';

  @override
  String get deleteTooltip => 'Удалить';

  @override
  String get deleteNoteTitle => 'Удалить заметку?';

  @override
  String deleteNoteMessage(Object title) {
    return '«$title» будет удалена.';
  }

  @override
  String get deleteReminderTitle => 'Удалить напоминание?';

  @override
  String deleteReminderMessage(Object title) {
    return '«$title» больше не будет напоминанием.';
  }

  @override
  String get reminderTitleHint => 'Название заметки';

  @override
  String get reminderContentHint => 'Текст заметки';

  @override
  String get success => 'Успешно';

  @override
  String get error => 'Ошибка';

  @override
  String get sectionDevelopment => 'Данный раздел находится в разработке';

  @override
  String get weApologize => 'Приносим свои извинения';

  @override
  String get errorAuthFailed => 'Не удалось завершить вход';

  @override
  String get errorProfileFailed => 'Не удалось получить данные аккаунта';

  @override
  String get errorInvalidLink => 'Некорректная ссылка';

  @override
  String get errorOpenLink => 'Не удалось открыть ссылку';

  @override
  String get errorNavigation => 'Ошибка перехода';

  @override
  String get errorNetwork => 'Нет подключения к интернету';

  @override
  String get errorTimeout => 'Превышено время ожидания запроса';

  @override
  String get errorUnknown => 'Неизвестная ошибка';
}
