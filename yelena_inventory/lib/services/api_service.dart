import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/branch_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5002/api';

  Future<List<BranchModel>> getBranches() async {
    final response = await http.get(Uri.parse('$baseUrl/Branches'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load branches');
    }

    final json = jsonDecode(response.body) as List<dynamic>;

    return json
        .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BranchModel> addBranch(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Branches'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': 0, 'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add branch');
    }

    return BranchModel.fromJson(jsonDecode(response.body));
  }

  Future<BranchModel> updateBranch(BranchModel branch) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Branches/${branch.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(branch.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update branch');
    }

    return BranchModel.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteBranch(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Branches/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete branch');
    }
  }
}
