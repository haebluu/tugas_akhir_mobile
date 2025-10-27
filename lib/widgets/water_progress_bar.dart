import 'package:flutter/material.dart';
import '../utils/colors.dart';

// Widget Indikator Progres Air
class WaterProgressIndicator extends StatelessWidget {
  final int currentIntake;
  final int target;
  final double progress;

  const WaterProgressIndicator({
    super.key,
    required this.currentIntake,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final isTargetMet = currentIntake >= target;
    final theme = Theme.of(context);
    
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    // FIX: Mengganti .withOpacity() yang deprecated
                    backgroundColor: accentColor.withAlpha((255 * 0.3).round()), 
                    valueColor: AlwaysStoppedAnimation<Color>(isTargetMet ? Colors.green : primaryColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentIntake ml',
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'dari $target ml',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isTargetMet ? 'Target Harian TERCAPAI! 🎉' : 'Terus Semangat Minum!',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isTargetMet ? Colors.green.shade700 : secondaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
