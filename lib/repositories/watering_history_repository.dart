import '../models/watering_history_model.dart';
import '../services/watering_history_service.dart';

class WateringHistoryRepository {
  final WateringHistoryService _service = WateringHistoryService();

  Future<List<WateringHistoryModel>> getWateringHistory(
    String plantId,
  ) async {
    return await _service.getWateringHistory(plantId);
  }

  Future<void> addWateringHistory(
    WateringHistoryModel history,
  ) async {
    await _service.addWateringHistory(history);
  }

  Future<void> deleteWateringHistory(String id) async {
    await _service.deleteWateringHistory(id);
  }
}