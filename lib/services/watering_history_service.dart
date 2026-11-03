
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/watering_history_model.dart';

class WateringHistoryService {
  final SupabaseClient _client = Supabase.instance.client;

  static const String _tableName = 'watering_history';

  // READ: Mengambil riwayat penyiraman berdasarkan ID tanaman.
  Future<List<WateringHistoryModel>> getWateringHistory(
    String plantId,
  ) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('plant_id', plantId)
        .order('watered_at', ascending: false);

    return (response as List)
        .map(
          (json) => WateringHistoryModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // CREATE: Menyimpan aktivitas penyiraman baru.
  Future<void> addWateringHistory(
    WateringHistoryModel history,
  ) async {
    await _client
        .from(_tableName)
        .insert(history.toJson());
  }

  // DELETE: Menghapus satu catatan riwayat penyiraman.
  Future<void> deleteWateringHistory(String id) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', id);
  }
}
