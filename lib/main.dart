import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- DIPERBAIKI: Impor paket Provider
import 'providers/hydration_provider.dart'; // <-- DIPERBAIKI: Impor kelas provider
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'utils/app_theme.dart';
import 'utils/colors.dart'; // <-- Dipastikan mengimpor konstanta warna

void main() {
  // Simulasi inisialisasi Firebase/API
  print('SIMULASI: Inisialisasi Firebase & Notifikasi...');
  runApp(
    // Error di sini teratasi setelah impor Provider
    ChangeNotifierProvider(
      create: (context) => HydrationProvider(),
      child: const HydraMateApp(),
    ),
  );
}

class HydraMateApp extends StatelessWidget {
  const HydraMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Error di sini teratasi setelah impor Provider
    final provider = context.watch<HydrationProvider>();
    final isDark = provider.isDarkMode;
    final isAuthenticated = provider.isAuthenticated;

    return MaterialApp(
      title: 'HydraMate',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      
      // Mengarahkan ke layar yang sesuai
      home: isAuthenticated ? const MainScreen() : const LoginScreen(),
    );
  }
}

// Halaman Utama dengan Bottom Navigation (Wrapper)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<HydrationProvider>().isDarkMode;
    final iconColor = isDark ? lightTextColor : secondaryColor;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: iconColor.withValues(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_outlined),
            activeIcon: Icon(Icons.water_drop),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
