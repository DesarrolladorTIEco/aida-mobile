import 'dart:convert';

import 'package:http/http.dart' as http;
import '../service.dart';

class ContainerService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> get_container(
      Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/get-containers';

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

  Future<List<Map<String, dynamic>>> check_photo_counts(
      Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/check-photo-counts';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        final dataList = responseBody['data'] as List<dynamic>;
        return dataList.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw 'Respuesta de API no contiene los datos esperados';
      }
    } else {
      throw 'Error en la solicitud: ${response.statusCode}';
    }
  }


  Future<List<Map<String, dynamic>>> check_photo_counts_all(
      Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/check-photo-counts-all';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        final dataList = responseBody['data'] as List<dynamic>;
        return dataList.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw 'Respuesta de API no contiene los datos esperados';
      }
    } else {
      throw 'Error en la solicitud: ${response.statusCode}';
    }
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/add-container';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      var responseData = json.decode(response.body);
      var message = responseData['message'];

      throw message;
    }
  }
}
