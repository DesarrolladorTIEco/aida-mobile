import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service.dart'; // Importa el archivo service.dart

class AuthService {
  final ApiService _apiService = ApiService();
  final String _resource = "mobile/";

  Future<Map<String, dynamic>> authenticate(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/mobile/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve el mapa decodificado
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

}
