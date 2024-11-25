import 'dart:convert';
import 'package:aida/services/christmas/worker_service.dart';
import 'package:flutter/material.dart';

import '../../data/models/christmas/worker_model.dart';

class WorkerViewModel extends ChangeNotifier {
  final WorkerService _workerService = WorkerService();

  String errorMessage = '';
  bool isLoading = false;

  // Metodo para manejar el save worker on christmas delivery

  Future<String> save(String workerDni, String responsibleDni, num user) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "dniTrabajador": workerDni,
        "dniResponsable": responsibleDni,
        "userId": user,
      };

      final response = await _workerService.save(data);

      if (response is Map<String, dynamic> && response.containsKey('Message')) {
        final message = response['Message'];

        print('Respuesta del servicio: $response');

        if (message.contains('Operación completada exitosamente')) {
          print("message " + message);
          return 'success';
        } else if (message.contains('Ya se entregó canasta')) {
          print("message " + message);
          return message;
        } else if (message
            .contains('El responsable no tiene stock suficiente')) {
          print("message " + message);
          return message;
        } else if (message.contains('No existe trabajador')) {
          print("message " + message);
          return message;
        } else {
          print("message " + message);
          return 'Mensaje no reconocido: $message';
        }
      } else {
        return 'No se recibió una respuesta válida del servidor.';
      }
    } catch (e) {
      return 'Hubo un error: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
