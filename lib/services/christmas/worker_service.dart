import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service.dart';

class WorkerService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}mobile/save_christmas';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody is List) {
        // Asumimos que es una lista con un solo mensaje en el primer elemento
        if (responseBody.isNotEmpty &&
            responseBody[0] is Map<String, dynamic>) {
          return responseBody[0];
        } else {
          throw Exception('La lista no contiene un Map<String, dynamic>.');
        }
      } else if (responseBody is Map<String, dynamic>) {
        return responseBody;
      } else {
        throw Exception('La respuesta no es válida.');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> get_worker_deliver_dni(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}mobile/get-worker-deliver';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es válida.');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }


  Future<List<Map<String, dynamic>>> get_worker_deliver_dni_byrange(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}mobile/get-worker-deliver-byrange';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es válida.');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }


  Future<List<Map<String, dynamic>>> get_worker_dni(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}mobile/get-worker-dni';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es válida.');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> get_stock_bydate(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}mobile/get-stock-date';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => e as Map<String, dynamic>).toList();
      } else if (responseBody is Map<String, dynamic>) {
        return [responseBody];
      } else {
        throw Exception('La respuesta no es válida.');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
