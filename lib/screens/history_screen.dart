import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/providers/hydration_provider.dart';
import 'dart:math';
import '../utils/colors.dart';

// Halaman Riwayat Asupan Air
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan paket provider diimpor untuk menggunakan context.watch
    final provider = context.watch<HydrationProvider>();
    final theme = Theme.of(context);
    final Random random = Random();

    // Filter log 7 hari terakhir (Simulasi)
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentLogs = provider.drinkHistory
        .where((log) => log.timestamp.isAfter(sevenDaysAgo))
        .toList();

    // Data untuk Chart (Simulasi)
    // Di aplikasi nyata, ini akan dihitung per hari dengan nilai yang bervariasi
    final dailyData = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      
      // LOGIKA BARU: Menghasilkan data yang lebih naik turun (random)
      // Base (2000ml) + Random (-500ml sampai +500ml)
      int mockIntake = 2000 + random.nextInt(1001) - 500;
      
      // Memastikan nilai tidak negatif dan masuk akal
      dailyData[dateKey] = mockIntake.clamp(500, 3500); 
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat & Statistik')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Asupan 7 Hari Terakhir', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    // Simulasi Chart (Di sini harusnya pakai fl_chart/syncfusion_flutter_charts)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor, width: 2)
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Simulasi Grafik 7 Hari',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                            ),
                            // Menampilkan data simulasi sebagai bukti bahwa datanya variatif
                            Text(
                              'Data: ${dailyData.values.join(', ')} ml', 
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tujuan: Menampilkan visualisasi data asupan air harian.',
                      style: theme.textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text('Log Detail', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            
            // List Log Detail
            ...recentLogs.map((log) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: accentColor),
                title: Text('${log.amountMl} ml air'),
                subtitle: Text('Tanggal: ${log.timestamp.day}/${log.timestamp.month} - Pukul ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}'),
                trailing: Text(
                  log.amountMl >= 500 ? 'Baik' : 'Normal',
                  style: TextStyle(color: log.amountMl >= 500 ? Colors.green : Colors.orange),
                ),
              ),
            )).toList().reversed,
            
          ],
        ),
      ),
    );
  }
}
