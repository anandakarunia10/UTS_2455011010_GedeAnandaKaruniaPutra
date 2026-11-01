import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_api_model.dart';

class PlantApiService {
  static const String _apiKey = 'sk-Ks066ae746817fb3520504';
  static const String _baseUrl = 'https://perenual.com/api/species-list';

  Future<List<PlantApiModel>> fetchPlants({String query = ''}) async {
    try {
      String url = '$_baseUrl?key=$_apiKey&page=1';
      if (query.isNotEmpty) {
        url = '$_baseUrl?key=$_apiKey&q=$query';
      }

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> plantList = data['data'] ?? [];

        return plantList.map((json) => PlantApiModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data tanaman (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Koneksi terganggu/Gagal terhubung ke REST API: $e');
    }
  }
}