import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_end_points.dart';
import '../model/user_list_model.dart';

class HomeRepo {
  Future<List<Data?>> getUserList({required String id,
    String? search = '',
    int? page,
    int? pageSize ,
  }) async {
    final url = Uri.parse(ApiEndPoints.getUserList(id: id,
        search: search, page: page.toString(), pageSize: pageSize.toString()));

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userListModel = UserListModel.fromJson(jsonData);
        return userListModel.data ?? [];
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }
}
