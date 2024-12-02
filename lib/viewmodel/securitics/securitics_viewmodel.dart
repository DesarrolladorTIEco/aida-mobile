import 'package:aida/services/securitics/securitics_service.dart';
import 'package:flutter/material.dart';

class SecuriticsViewModel extends ChangeNotifier {
  final SecuriticsService _securiticsService = SecuriticsService();

  String errorMessage = '';
  bool isLoading = false;

  List<Map<String, dynamic>> cultive = [];
  List<Map<String, dynamic>> registerZone = [];

  Future<void> fetchCultives() async {
    isLoading = true; // Mostrar indicador de carga
    notifyListeners();

    try {
      final response = await _securiticsService.get_cultive();
      cultive = response;
    } catch (e) {
      print('Error al obtener módulos: $e');
    }finally {
      isLoading = false; // Ocultar indicador de carga
      notifyListeners();
    }
  }

  Future<void> fetchRegisterZones() async {
    isLoading = true; // Mostrar indicador de carga
    notifyListeners();

    try {
      final response = await _securiticsService.get_register_zone();
      registerZone = response;
    } catch (e) {
      errorMessage = 'Error al obtener zonas: $e';
    } finally {
      isLoading = false; // Ocultar indicador de carga
      notifyListeners();
    }
  }

}