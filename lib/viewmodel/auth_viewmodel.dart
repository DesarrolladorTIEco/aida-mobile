import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../data/models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String errorMessage = '';
  bool isLoading = false;
  String fullName = ''; // Añadir la propiedad fullName
  String userID = ''; // Añadir la propiedad userID

  // Método para manejar el login
  Future<UserModel?> login(String user, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {"user": user, "password": password};
      final response = await _authService.authenticate(data);

      if (response['message'] == 'Autenticación exitosa') {
        // Guardamos el nombre completo en el provider
        fullName = response['session_data']['user']['UsrFullName'] ??
            'Nombre no disponible';
        userID = response['session_data']['user']['UsrID'] ?? 0;
        notifyListeners();

        return UserModel.fromJson(response['session_data']['user']);
      } else {
        errorMessage = 'Credenciales incorrectas';
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
