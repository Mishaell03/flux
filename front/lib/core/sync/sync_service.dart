import 'package:front/core/db/database_provider.dart';

class SyncService {
  final db = DatabaseProvider.instance;

  Future<void> syncFromBackend() async {
    // 1. получить изменения с backend
    // 2. обновить drift
  }

  Future<void> pushToBackend() async {
    // 1. взять локальные изменения
    // 2. отправить на backend
  }

  Future<void> fullSync() async {
    await pushToBackend();
    await syncFromBackend();
  }
}