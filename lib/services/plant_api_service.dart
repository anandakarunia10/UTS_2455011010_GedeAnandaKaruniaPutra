import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_api_model.dart';

class PlantApiService {
  // Free Demo API Key dari Perenual atau Endpoint Public
  static const String _baseUrl = 'https://perenual.com/api/species-list?key=sk-default&page=1';

  Future<List<PlantApiModel>> fetchPlants({String query = ''}) async {
    try {
      String url = _baseUrl;
      if (query.isNotEmpty) {
        url = 'https://perenual.com/api/species-list?key=sk-default&q=$query';
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