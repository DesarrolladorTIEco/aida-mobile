import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../data/models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String errorMessage = '';
  bool isLoading = false;
  String fullName = ''; // Añadir la propiedad fullName
  String userID = ''; // Añadir la propiedad userID
  List<Map<String, dynamic>> modules = []; // Agrega esta lista para almacenar los módulos

  Future<void> fetchModules(String userID) async {
    try {
      // Aquí llamas a tu servicio que hace la petición a la API
      final response = await _authService.getModules(userID);
      modules = response; // Asignas la respuesta a la lista de módulos
      notifyListeners(); // Notificas a los oyentes para que se actualice la UI
    } catch (e) {
      // Manejo de errores
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

      if (response['message'] == 'Autenticación exitosa') {
        fullName = response['session_data']['user']['UsrFullName'] ??
            'Nombre no disponible';
        userID = response['session_data']['user']['UsrID'] ?? 0;
        await fetchModules(userID); // Llama a fetchModules después de iniciar sesión

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
