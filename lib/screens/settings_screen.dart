import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/providers/provider.dart';
import '../utils/colors.dart';

// Halaman Pengaturan
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HydrationProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Pengaturan Target Harian
          ListTile(
            leading: Icon(Icons.rule, color: secondaryColor),
            title: const Text('Target Air Harian (ml)'),
            subtitle: Text('${provider.dailyTargetMl} ml'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSetGoalDialog(context),
          ),
          const Divider(),

          // Pengaturan Notifikasi/Reminder
          SwitchListTile(
            secondary: Icon(Icons.notifications_active, color: secondaryColor),
            title: const Text('Aktifkan Pengingat Minum'),
            value: provider.isReminderEnabled,
            onChanged: (value) => provider.toggleReminder(value),
          ),
          ListTile(
            enabled: provider.isReminderEnabled,
            leading: Icon(Icons.schedule, color: provider.isReminderEnabled ? secondaryColor : Colors.grey),
            title: const Text('Interval Pengingat'),
            subtitle: Text('Setiap ${provider.reminderIntervalHours} jam'),
            trailing: const Icon(Icons.chevron_right),
            onTap: provider.isReminderEnabled ? () => _showReminderIntervalDialog(context) : null,
          ),
          const Divider(),

          // Pengaturan Tampilan
          SwitchListTile(
            secondary: Icon(Icons.brightness_2, color: secondaryColor),
            title: const Text('Mode Gelap (Dark Mode)'),
            value: provider.isDarkMode,
            onChanged: (value) => provider.toggleDarkMode(value),
          ),
          const Divider(),
          
          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout (Simulasi)', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              await provider.logout();
              // Navigasi ke LoginScreen akan diurus oleh main.dart
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda telah keluar (Simulasi).'))
              );
            },
          ),
        ],
      ),
    );
  }

  // Dialog untuk mengatur target
  void _showSetGoalDialog(BuildContext context) {
    final provider = context.read<HydrationProvider>();
    final TextEditingController controller = TextEditingController(text: provider.dailyTargetMl.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atur Target Harian (ml)'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Contoh: 2500"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTarget = int.tryParse(controller.text);
                if (newTarget != null && newTarget > 500) {
                  provider.setDailyTarget(newTarget);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Target minimal adalah 500 ml.'))
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
  
  // Dialog untuk mengatur interval reminder
  void _showReminderIntervalDialog(BuildContext context) {
    final provider = context.read<HydrationProvider>();
    int selectedHours = provider.reminderIntervalHours;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atur Interval Pengingat'),
          content: DropdownButtonFormField<int>(
            value: selectedHours,
            decoration: const InputDecoration(labelText: "Interval (Jam)"),
            items: [1, 2, 3, 4, 6].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Setiap $value jam'),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                selectedHours = newValue;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.setReminderInterval(selectedHours);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
