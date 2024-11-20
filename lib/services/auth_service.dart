import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service.dart'; // Importa el archivo service.dart

class AuthService {
  final ApiService _apiService = ApiService();

  //login
  Future<Map<String, dynamic>> authenticate(Map<String, dynamic> data) async {
    // Construye la URL usando la URL base de ApiService
    final String url = '${_apiService.baseUrl}mobile/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve el mapa decodificado
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  //session()


  //logout
}
