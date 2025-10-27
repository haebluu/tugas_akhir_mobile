class UserModel {
  final String userId;
  final String email;
  String userName;
  int dailyTargetMl;
  bool isDarkMode;
  
  UserModel({
    required this.userId,
    required this.email,
    required this.userName,
    this.dailyTargetMl = 2000,
    this.isDarkMode = false,
  });
  
  // Metode sederhana untuk memperbarui nama dan target
  void updateUserInfo({String? newName, int? newTarget}) {
    if (newName != null) userName = newName;
    if (newTarget != null && newTarget > 500) dailyTargetMl = newTarget;
  }
}
