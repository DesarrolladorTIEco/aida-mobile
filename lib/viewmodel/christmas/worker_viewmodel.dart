import 'dart:convert';
import 'package:aida/services/christmas/worker_service.dart';
import 'package:flutter/material.dart';

import '../../data/models/christmas/worker_model.dart';

class WorkerViewModel extends ChangeNotifier {
  final WorkerService _workerService = WorkerService();

  String errorMessage = '';
  bool isLoading = false;

  // Metodo para manejar el save worker on christmas delivery

  Future<WorkerModel?> save(
      String workerDni,
      String responsibleDni,
      num user
      ) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "dniTrabajador" : workerDni,
        "dniResponsable" : responsibleDni,
        "userId" : user
      };

      final response = await _workerService.save(data);

      if(response != null ){
        if(response['Message'] == 'Operación completada exitosamente') {
          final worker = WorkerModel.fromJson(response['Message']);
          notifyListeners();
          return worker;
        }else {
          errorMessage =
          "Hubo un error: ${response['Message'] ?? 'Error desconocido'}";
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
      print("Error:  ${e.toString()}");
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}