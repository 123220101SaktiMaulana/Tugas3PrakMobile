import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String baseUrl = 'https://dattebayo-api.onrender.com/';

  static Future<List<dynamic>> getList(String endpoint) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[endpoint] ?? []; // Mengambil list berdasarkan nama endpoint
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> getDetail(String endpoint, int id) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load detail data');
    }
  }
}
