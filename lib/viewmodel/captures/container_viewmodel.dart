import 'package:aida/data/models/captures/container_model.dart';
import 'package:aida/services/captures/container_service.dart';
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

  Future<ContainerModel?> insert(String name, String cultive, String zone,
      String date, num user, String directory, num bkId) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "MbCntNameContainer": name,
        "MbCntCultive": cultive,
        "MbCntZone": zone,
        "SecDateCreate": date,
        "UsrCreate": user,
        "MbCntLinkDirectory": directory,
        "MbBkId": bkId,
      };

      final response = await _containerService.insert(data);

      if (response['original']['success'] == true) {
        final container =
            ContainerModel.fromJson(response['original']['container']);

        notifyListeners();
        return container;
      } else {
        errorMessage = response['original']['error'] ?? 'Error desconocido';
        print("Error en la respuesta: $errorMessage");
      }
    } catch (e) {
      errorMessage = '$e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> fetchContainer(String cultive, String zone, num bkId) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {'MbCntCultive': cultive, 'MbCntZone': zone, 'BkId': bkId};

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
