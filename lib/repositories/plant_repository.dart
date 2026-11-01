import '../models/plant_api_model.dart';
import '../services/plant_api_service.dart';

class PlantRepository {
  final PlantApiService _apiService = PlantApiService();

  Future<List<PlantApiModel>> getPlants({String query = ''}) async {
    return await _apiService.fetchPlants(query: query);
  }
}