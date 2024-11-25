import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../data/models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String errorMessage = '';
  bool isLoading = false;
  String fullName = '';
  String userID = '';
  String userDni = '';

  List<Map<String, dynamic>> modules = [];

  Future<void> fetchModules(String userID) async {
    try {
      final response = await _authService.getModules(userID);
      modules = response;
      notifyListeners();
    } catch (e) {
      print('Error al obtener módulos: $e');
    }
  }

  // Método para manejar el login
  Future<UserModel?> login(String user, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {"user": user, "password": password};
      final response = await _authService.authenticate(data);

      if (response['message'] == 'Credenciales incorrectas') {
        errorMessage = 'Credenciales incorrectas';
        notifyListeners();
        return null;
      }

      if (response.containsKey('session_data')) {
        fullName = response['session_data']['user']['UsrFullName'] ??
            'Nombre no disponible';
        userID = response['session_data']['user']['UsrID'] ?? 0;
        userDni = response['session_data']['user']['UsrDni'] ?? '';
        await fetchModules(userID);

        notifyListeners();
        return UserModel.fromJson(response['session_data']['user']);
      } else {
        errorMessage = 'Error inesperado en la autenticación';
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Hubo un error: ${e.toString()}';
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
