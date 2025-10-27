import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/providers/hydration_provider.dart';
import '../utils/colors.dart';

// Widget Tombol Tambah Air Cepat
class AddWaterButton extends StatelessWidget {
  const AddWaterButton({super.key});
  
  final List<int> quickOptions = const [250, 500, 750];

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HydrationProvider>();
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tambahkan Asupan Cepat',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: quickOptions.map((amount) {
                return ElevatedButton(
                  onPressed: () => provider.addWater(amount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: darkTextColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    '+${amount}ml',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showCustomAddDialog(context, provider.addWater),
              icon: const Icon(Icons.add_circle, color: Colors.white),
              label: const Text('Tambah Jumlah Lain', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Dialog untuk menambah jumlah custom
  void _showCustomAddDialog(BuildContext context, Function(int amount) onAdd) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Asupan Air (ml)'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Jumlah dalam ml, contoh: 330"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final customAmount = int.tryParse(controller.text);
                if (customAmount != null && customAmount > 0) {
                  onAdd(customAmount);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Masukkan jumlah yang valid.'))
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
