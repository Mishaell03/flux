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
  String get profileSyncLastSync => 'Последняя синх.';

  @override
  String get profileSyncSynced => 'Синхр.';

  @override
  String get profileSyncLastSyncValue => 'Сегодня';

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
  String get notesUntitled => 'Без названия';

  @override
  String get notesNoContent => 'Пока нет текста';

  @override
  String get notesOpenPlaceholder => 'Открытие заметки пока не реализовано';

  @override
  String get reminderOpenPlaceholder =>
      'Открытие напоминания пока не реализовано';

  @override
  String get createNotePlaceholder => 'Создание заметки пока не реализовано';

  @override
  String get createReminderPlaceholder =>
      'Создание напоминания пока не реализовано';

  @override
  String get createNote => 'Создать заметку';

  @override
  String get createReminder => 'Создать напоминание';

  @override
  String get noteCreateTitle => 'Новая заметка';

  @override
  String get noteTitleLabel => 'Название';

  @override
  String get noteContentLabel => 'Текст';

  @override
  String get noteTitleHint => 'Напиши название';

  @override
  String get noteContentHint => 'Напиши что-нибудь...';

  @override
  String get noteSave => 'Сохранить';

  @override
  String get noteCancel => 'Отмена';

  @override
  String get noteCreated => 'Заметка создана';

  @override
  String get success => 'Успешно';

  @override
  String get error => 'Ошибка';

  @override
  String get sectionDevelopment => 'Данный раздел находится в разработке';

  @override
  String get weApologize => 'Приносим свои извинения';

  @override
  String get errorCouldNotOpenLink => 'Не удалось открыть ссылку';

  @override
  String get errorServerUnavailable => 'Сервер недоступен';

  @override
  String get errorNetworkUnavailable => 'Нет подключения к интернету';

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
  String get errorNotFound => 'Ресурс не найден';

  @override
  String get errorValidation => 'Неверные данные';

  @override
  String get errorUnauthorized => 'Требуется авторизация';

  @override
  String get errorServer => 'Ошибка сервера, попробуйте позже';

  @override
  String get errorInvalidResponse => 'Некорректный ответ сервера';

  @override
  String get errorUnknown => 'Неизвестная ошибка';
}
