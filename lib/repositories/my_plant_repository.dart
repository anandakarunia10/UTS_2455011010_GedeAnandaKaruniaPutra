import '../models/my_plant_model.dart';
import '../services/supabase_service.dart';

class MyPlantRepository {
  final SupabaseService _supabaseService = SupabaseService();

  Future<List<MyPlantModel>> getMyPlants(String studentId) async {
    return await _supabaseService.getMyPlants(studentId);
  }

  Future<void> addPlant(MyPlantModel plant) async {
    await _supabaseService.addPlant(plant);
  }

  Future<void> updatePlant(String id, Map<String, dynamic> updates) async {
    await _supabaseService.updatePlant(id, updates);
  }

  Future<void> deletePlant(String id) async {
    await _supabaseService.deletePlant(id);
  }
}