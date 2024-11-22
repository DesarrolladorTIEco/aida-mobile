import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service.dart'; // Importa el archivo service.dart

class AuthService {
  final ApiService _apiService = ApiService();


  Future<List<Map<String, dynamic>>> getModules(String userID) async {
    final String url = '${_apiService.baseUrl}mobile/get-modules';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userID': userID}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  //login
  Future<Map<String, dynamic>> authenticate(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}mobile/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Devuelve la respuesta exitosa
      } else if (response.statusCode == 401) {
        // Maneja el error 401 devolviendo un mensaje de error
        return {
          'message': 'Credenciales incorrectas',
        };
      } else {
        throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Hubo un error: $e');
    }
  }

}
