import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aida/services/service.dart';

class PhotoService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> insert(Map<String, dynamic> data) async {
    final String url = '${_apiService.baseUrl}securitic/add-photo-capture';

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
