import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Perbaikan jalur impor
import '../models/drink_log_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';

class HydrationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  
  // Log Minum (Mock History)
  final List<DrinkLog> _drinkHistory = [
    // Data mock hari ini
    DrinkLog(500, DateTime.now().subtract(const Duration(hours: 4))),
    DrinkLog(250, DateTime.now().subtract(const Duration(hours: 2))),
  ];

  int _currentIntakeMl = 0;
  bool _isReminderEnabled = true;
  int _reminderIntervalHours = 2; // Setiap 2 jam
  String _weatherCondition = 'Memuat...';
  
  // Getters untuk mengakses state
  bool get isAuthenticated => _authService.isLoggedIn;
  UserModel? get currentUser => _currentUser;
  int get dailyTargetMl => _currentUser?.dailyTargetMl ?? 2000;
  int get currentIntakeMl => _currentIntakeMl;
  double get progressPercentage => min(1.0, _currentIntakeMl / dailyTargetMl);
  bool get isDarkMode => _currentUser?.isDarkMode ?? false;
  bool get isReminderEnabled => _isReminderEnabled;
  int get reminderIntervalHours => _reminderIntervalHours;
  List<DrinkLog> get drinkHistory => _drinkHistory;
  String get weatherCondition => _weatherCondition;


  HydrationProvider() {
    _loadInitialData();
  }

  void _loadInitialData() async {
    // Simulasi Autentikasi dan Load User
    if (_authService.isLoggedIn) {
      _currentUser = UserModel(
        userId: _authService.currentUserId!,
        email: 'test@hydramate.com',
        userName: 'Pengguna HydraMate',
      );
    }
    
    _currentIntakeMl = _drinkHistory.fold(0, (sum, log) => sum + log.amountMl);
    notifyListeners();

    await _applyWeatherTarget();
  }
  
  // Aksi Auth (Simulasi)
  Future<bool> attemptLogin(String email, String password) async {
    final success = await _authService.signIn(email, password);
    if (success) {
      _currentUser = UserModel(
        userId: _authService.currentUserId!,
        email: email,
        userName: 'Pengguna HydraMate',
      );
      _loadInitialData(); // Muat ulang data setelah login
    }
    notifyListeners();
    return success;
  }
  
  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Aksi: Menambah Asupan Air
  void addWater(int amountMl) {
    if (amountMl > 0) {
      _currentIntakeMl += amountMl;
      _drinkHistory.add(DrinkLog(amountMl, DateTime.now()));
      // print('Log: Ditambahkan $amountMl ml. Total: $_currentIntakeMl ml'); // Dihapus karena avoid_print
      notifyListeners();
      
      if (_currentIntakeMl >= dailyTargetMl) {
        // print('MOTIVASI: Target Harian Tercapai!'); // Dihapus karena avoid_print
      }
    }
  }

  // Aksi: Mengatur Target Harian
  void setDailyTarget(int newTarget) {
    if (newTarget > 500 && _currentUser != null) {
      _currentUser!.dailyTargetMl = newTarget;
      // print('Target baru diatur: $newTarget ml'); // Dihapus karena avoid_print
      notifyListeners();
    }
  }
  
  // Aksi: Mengubah Dark Mode
  void toggleDarkMode(bool value) {
    if (_currentUser != null) {
      _currentUser!.isDarkMode = value;
      notifyListeners();
    }
  }
  
  // Aksi: Mengubah Status Reminder
  void toggleReminder(bool value) {
    _isReminderEnabled = value;
    if (value) {
      _notificationService.scheduleReminder(_reminderIntervalHours);
    } else {
      _notificationService.cancelAllReminders();
    }
    notifyListeners();
  }
  
  // Aksi: Mengubah Interval Reminder
  void setReminderInterval(int hours) {
    _reminderIntervalHours = hours;
    if (_isReminderEnabled) {
       _notificationService.scheduleReminder(hours);
    }
    notifyListeners();
  }
  
  // Aksi: Mengambil Cuaca dan Menyesuaikan Target
  Future<void> _applyWeatherTarget() async {
    try {
      final weatherData = await _apiService.fetchWeather('Jakarta');
      _weatherCondition = '${weatherData['temperature_celsius']}°C, ${weatherData['condition']}';
      bool isWeatherHot = weatherData['isHot'] as bool;

      if (isWeatherHot && _currentUser != null) {
        // Logika: Jika cuaca panas, target naik 500ml
        if (_currentUser!.dailyTargetMl == 2000) { 
           _currentUser!.dailyTargetMl = 2500; 
           // print('PENYESUAIAN TARGET: Cuaca panas, target naik menjadi ${_currentUser!.dailyTargetMl} ml.'); // Dihapus karena avoid_print
        }
      } else if (_currentUser != null) {
         if (_currentUser!.dailyTargetMl == 2500) {
             _currentUser!.dailyTargetMl = 2000;
         }
      }
    } catch (e) {
      _weatherCondition = 'Gagal memuat cuaca';
      // print('Error simulasi cuaca: $e'); // Dihapus karena avoid_print
    }
    notifyListeners();
  }
}
