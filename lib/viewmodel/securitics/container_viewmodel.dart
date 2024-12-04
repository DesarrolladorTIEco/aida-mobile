import 'package:aida/data/models/securitics/container_model.dart';
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

  Future<ContainerModel?> insert(
      String name, String cultive, String zone, String date, num user) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "MbCntNameContainer" : name,
        "MbCntCultive" : cultive,
        "MbCntZone" : zone,
        "SecDateCreate" : date,
        "UsrCreate" : user,
      };
      
      final response = await _containerService.insert(data);
      
      if(response != null) {
        if(response['original']['success'] == true){
          final container = ContainerModel.fromJson(response['original']['container']);
          notifyListeners();
          return container;
        } else {
          errorMessage =
          "Hubo un error: ${response['original']['message'] ?? 'Error desconocido'}";
          notifyListeners();
          return null;
        }
      }else {
        errorMessage = "No se recibió respuesta del servidor.";
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Hubo un error: ${e.toString()}';
      print("Error: ${e.toString()}");
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
