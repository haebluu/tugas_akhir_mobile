// Simulasi layanan Firebase Authentication
class AuthService {
  // Status login simulasi
  bool _isLoggedIn = false;
  String? _currentUserId = 'user_hydramate_123';
  
  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserId => _currentUserId;

  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Logika simulasi: sukses jika email dan password tidak kosong
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      print('SIMULASI AUTH: Berhasil login sebagai $email');
      return true;
    }
    return false;
  }
  
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    print('SIMULASI AUTH: Pengguna berhasil Logout.');
  }
}
