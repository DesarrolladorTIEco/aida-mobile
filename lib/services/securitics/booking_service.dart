import 'dart:convert';

import 'package:http/http.dart' as http;
import '../service.dart';

class BookingService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> get_booking(
      Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/get-booking';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es valida');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> get_booking_terminado(
      Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/get-booking-terminado';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es valida');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/add-booking';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else{
      var responseData = json.decode(response.body);
      var message = responseData['message'];

      throw message;
    }
  }
}