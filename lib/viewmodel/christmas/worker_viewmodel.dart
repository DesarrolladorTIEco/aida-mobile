import 'dart:convert';
import 'package:aida/services/christmas/worker_service.dart';
import 'package:flutter/material.dart';

import '../../data/models/christmas/worker_model.dart';

class WorkerViewModel extends ChangeNotifier {
  final WorkerService _workerService = WorkerService();

  String errorMessage = '';
  bool isLoading = false;

  List<Map<String, dynamic>> _workers = [];

  List<Map<String, dynamic>> get workers => _workers;

  // Método para limpiar los trabajadores
  void clearWorkers() {
    _workers.clear();
    notifyListeners(); // Notificar a los listeners (pantalla) que la lista se ha actualizado
  }

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
          return 'success';
        } else if (message.contains('Ya se entregó canasta')) {
          return message;
        } else if (message
            .contains('El responsable no tiene stock suficiente')) {
          return message;
        } else if (message.contains('No existe trabajador')) {
          return message;
        } else {
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

  Future<void> fetchWorkers(String userDni, String date) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "dni": userDni,
        "date": date,
      };

      final response = await _workerService.get_worker_deliver_dni(data);
      print('Respuesta de la API: $response');

      if (response is List && response.isNotEmpty) {
        _workers = List<Map<String, dynamic>>.from(response); // Asigna la lista de trabajadores si no está vacía
      } else {
        // Si no hay trabajadores, dejamos la lista vacía
        _workers = [];
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al obtener los trabajadores: ${e.toString()}';
      print('Error: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWorkerDni(String userDni) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "dni": userDni
      };

      final response = await _workerService.get_worker_dni(data);
      print('Respuesta de la API: $response');

      if (response is List && response.isNotEmpty) {
        _workers = List<Map<String, dynamic>>.from(response); // Asigna la lista de trabajadores si no está vacía
      } else {
        // Si no hay trabajadores, dejamos la lista vacía
        _workers = [];
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al obtener los trabajadores: ${e.toString()}';
      print('Error: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
