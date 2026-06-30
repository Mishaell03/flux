import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied) {
    final result = await Permission.notification.request();
    if (result.isPermanentlyDenied) {
      // пользователь отказал — предложите открыть настройки
      await openAppSettings();
    }
  }
}