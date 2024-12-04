import 'package:aida/services/securitics/container_service.dart';
import 'package:flutter/material.dart';

class ContainerViewModel extends ChangeNotifier {
  final ContainerService _containerService = ContainerService();

  String errorMessage = '';
  bool isLoading = false;

  List<Map<String, dynamic>> _containers = [];

  List<Map<String, dynamic>> get containers => _containers;

  void clearContainer() {
    _containers.clear();
    notifyListeners();
  }

  Future<void> fetchContainer(String cultive, String zone) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {'MbCntCultive': cultive, 'MbCntZone': zone};

      final response = await _containerService.get_container(data);
      print('Respuesta de la API: $response');

      if (response.isNotEmpty) {
        _containers = List<Map<String, dynamic>>.from(response);
      } else {
        _containers = [];
      }
    } catch (e) {
      errorMessage = 'Error al obtener los contenedores: ${e.toString()}';
      print('Error: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
