import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // final String _baseUrl = 'http://api.ecosac.com.pe:58000/api/'; // API PUBLICA
  //final String _baseUrl = 'http://10.0.2.2:8000/api/';  // emulador android
  final String _baseUrl = 'http://10.10.200.159:8000/api/';  // emulador físico

  String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }
}
