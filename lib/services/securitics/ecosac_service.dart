import 'dart:convert';

import 'package:http/http.dart' as http;
import '../service.dart';

class SecuriticsService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> get_cultive() async {
    final String url = '${_apiService.baseUrl}securitic/get-cultive';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        print(responseBody);
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception(' La respuesta no es válidad en este servicio');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> get_register_zone() async {
    final String url = '${_apiService.baseUrl}securitic/get-register-zone';

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
        throw Exception(' La respuesta no es válidad en este servicio');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
