import 'package:flutter/material.dart';
import '../models/plant_api_model.dart';
import '../repositories/plant_repository.dart';

class PlantProvider with ChangeNotifier {
  final PlantRepository _repository = PlantRepository();

  List<PlantApiModel> _plants = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<PlantApiModel> get plants => _plants;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPlants({String query = ''}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _plants = await _repository.getPlants(query: query);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}