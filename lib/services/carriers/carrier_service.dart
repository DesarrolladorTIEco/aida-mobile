import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service.dart';

class CarrierService {
  final ApiService _apiService = ApiService();

  //insert carrier
  Future<Map<String, dynamic>> insert(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}carrier/insert-carrier';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> get_areas() async {
    final String url = '${_apiService.baseUrl}carrier/get-areas';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es válida');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
