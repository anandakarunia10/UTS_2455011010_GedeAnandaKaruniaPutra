import 'package:flutter/material.dart';
import '../models/my_plant_model.dart';
import '../repositories/my_plant_repository.dart';

class MyPlantProvider with ChangeNotifier {
  final MyPlantRepository _repository = MyPlantRepository();
  final String _studentId = '2455011010'; // NIM Anda

  List<MyPlantModel> _myPlants = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<MyPlantModel> get myPlants => _myPlants;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMyPlants() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _myPlants = await _repository.getMyPlants(_studentId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPlant(MyPlantModel plant) async {
    try {
      await _repository.addPlant(plant);
      await fetchMyPlants();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePlant(String id, Map<String, dynamic> updates) async {
    try {
      await _repository.updatePlant(id, updates);
      await fetchMyPlants();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePlant(String id) async {
    try {
      await _repository.deletePlant(id);
      await fetchMyPlants();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}