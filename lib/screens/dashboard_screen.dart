import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/providers/hydration_provider.dart';
import '../widgets/water_progress_bar.dart';
import '../widgets/add_water_button.dart';
import '../utils/colors.dart';

// Halaman Dashboard Utama
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HydrationProvider>();
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleLarge;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('HydraMate', style: textStyle?.copyWith(color: Colors.white)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Selamat Datang, ${provider.currentUser?.userName ?? 'Pengguna'}!', style: textStyle),
            const SizedBox(height: 8),
            Text('Cuaca saat ini: ${provider.weatherCondition}', style: theme.textTheme.bodySmall),
            const SizedBox(height: 24),

            // Progress Indikator
            WaterProgressIndicator(
              currentIntake: provider.currentIntakeMl,
              target: provider.dailyTargetMl,
              progress: provider.progressPercentage,
            ),
            const SizedBox(height: 32),

            // Tombol Tambah Air
            const AddWaterButton(),
            const SizedBox(height: 20),

            // Log Minum Hari Ini
            Text('Log Minum Hari Ini', style: textStyle),
            const SizedBox(height: 12),
            ...provider.drinkHistory
                .where((log) => log.timestamp.day == DateTime.now().day)
                .map((log) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Icon(Icons.local_drink, color: primaryColor),
                    title: Text('${log.amountMl} ml', style: theme.textTheme.bodyMedium),
                    trailing: Text(
                      'Pukul ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                )).toList().reversed, // Tampilkan log terbaru di atas
          ],
        ),
      ),
    );
  }
}
