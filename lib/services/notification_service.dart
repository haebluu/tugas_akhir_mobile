// Simulasi layanan Notifikasi Lokal (flutter_local_notifications)
class NotificationService {
  Future<void> scheduleReminder(int intervalHours) async {
    // Di lingkungan nyata, ini akan menggunakan `flutter_local_notifications`
    print('SIMULASI NOTIFIKASI: Pengingat diatur setiap $intervalHours jam.');
  }
  
  Future<void> cancelAllReminders() async {
    print('SIMULASI NOTIFIKASI: Semua pengingat dibatalkan.');
  }
}
