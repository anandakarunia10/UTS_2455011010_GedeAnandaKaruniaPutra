import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/my_plant_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'my_plants';

  // 1. READ Data (GET)
  Future<List<MyPlantModel>> getMyPlants(String studentId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => MyPlantModel.fromJson(json))
        .toList();
  }

  // 2. CREATE Data (POST)
  Future<void> addPlant(MyPlantModel plant) async {
    await _client.from(_tableName).insert(plant.toJson());
  }

  // 3. UPDATE Data (PUT/PATCH)
  Future<void> updatePlant(String id, Map<String, dynamic> updates) async {
    await _client.from(_tableName).update(updates).eq('id', id);
  }

  // 4. DELETE Data (DELETE)
  Future<void> deletePlant(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }
}