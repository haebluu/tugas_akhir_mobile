// Simulasi layanan API Cuaca (OpenWeather)
class ApiService {
  // Simulasi: Mengambil data cuaca
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Contoh data mock: 30°C, Berawan (Asumsikan Jakarta)
    return {
      'temperature_celsius': 30,
      'condition': 'Berawan',
      'city': city,
      'isHot': 30 > 28, // Jika > 28°C dianggap panas
    };
  }
}
