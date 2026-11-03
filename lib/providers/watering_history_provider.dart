import 'package:flutter/material.dart';

import '../models/watering_history_model.dart';
import '../repositories/watering_history_repository.dart';

class WateringHistoryProvider extends ChangeNotifier {
  final WateringHistoryRepository _repository =
      WateringHistoryRepository();

  List<WateringHistoryModel> _histories = [];

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<WateringHistoryModel> get histories => _histories;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  // Mengambil riwayat penyiraman berdasarkan ID tanaman.
  Future<void> fetchHistory(String plantId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _histories = await _repository.getWateringHistory(plantId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan riwayat penyiraman baru.
  Future<bool> addWateringHistory({
    required String plantId,
    String? notes,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final history = WateringHistoryModel(
        plantId: plantId,
        wateredAt: DateTime.now(),
        notes: notes,
      );

      await _repository.addWateringHistory(history);

      _histories = await _repository.getWateringHistory(plantId);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Menghapus satu riwayat penyiraman.
  Future<bool> deleteWateringHistory({
    required String id,
    required String plantId,
  }) async {
    _errorMessage = null;

    try {
      await _repository.deleteWateringHistory(id);

      _histories = await _repository.getWateringHistory(plantId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Membersihkan data ketika berpindah tanaman.
  void clearHistory() {
    _histories = [];
    _errorMessage = null;
    notifyListeners();
  }
}