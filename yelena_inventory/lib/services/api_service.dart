import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5002/api';

  Future<List<dynamic>> getBranches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Branches'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load branches');
    }

    return jsonDecode(response.body) as List<dynamic>;
  }
}