import 'dart:convert';
import 'dart:io';

import 'package:chat_socket_practice/model/register_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../config/api_end_points.dart';
import '../model/login_model.dart';

class AuthRepo {

  Future<RegisterModel> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String password,
    required File? profileImage,
  }) async {
    try {
      final dio = Dio();

      FormData formData = FormData.fromMap({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "code": countryCode,
        "phone": phoneNumber,
        "password": password,
        if (profileImage != null)
          "profileImage": await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
            ),

      });

      final response = await dio.post(
        ApiEndPoints.register(),
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER RESPONSE: ${response.data}");

      return RegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      print("statusCode: ${e.response?.statusCode}");
      print("errorData: ${e.response?.data}");

      throw Exception(
        e.response?.data['message'] ?? 'Error: ${e.response?.statusCode}',
      );
    }
  }


  Future<LoginModel> loginUser ({
    required String email,
    required String password,
  })
  async
  {
    final Map<String , dynamic> body = {
      "email": email,
      "password": password,
    };
    final url = Uri.parse(ApiEndPoints.login());

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return LoginModel.fromJson(jsonData);

    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  }

}