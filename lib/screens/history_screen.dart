import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- DIPERBAIKI: Impor paket Provider
import 'package:tugas_akhir/providers/hydration_provider.dart';
import '../utils/colors.dart';

// Halaman Riwayat Asupan Air
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HydrationProvider>();
    final theme = Theme.of(context);

    // Filter log 7 hari terakhir (Simulasi)
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentLogs = provider.drinkHistory
        .where((log) => log.timestamp.isAfter(sevenDaysAgo))
        .toList();

    // Data untuk Chart (Simulasi)
    // Di aplikasi nyata, ini akan dihitung per hari
    final dailyData = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      // Mock data
      dailyData[dateKey] = 2000 - i * 100 + (date.day % 3) * 500; 
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
                    // Simulasi Chart (Di sini harusnya pakai fl_chart)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor, width: 2)
                      ),
                      child: Center(
                        child: Text(
                          'Simulasi Grafik 7 Hari\n(Di sini akan tampil fl_chart)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
