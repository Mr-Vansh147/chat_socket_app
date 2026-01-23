import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_end_points.dart';
import '../model/update_profile_model.dart';
import '../model/user_profile_model.dart';

class ProfileRepo {
  Future<UserProfileModel> getProfile({required String id}) {
    final url = Uri.parse(ApiEndPoints.getProfile(userId: id));
    return http
        .get(url, headers: {"Content-Type": "application/json"})
        .then((response) {
          print("BODY: ${response.body}");

          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            return UserProfileModel.fromJson(jsonData);
          } else {
            throw Exception("Error: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Request failed: $error");
        });
  }

  Future<UpdateProfileModel> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
  }) {
    final url = Uri.parse(ApiEndPoints.updateProfile(userId: id));
    final request = http.MultipartRequest('PUT', url);

    request.fields.addAll({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "code": countryCode,
      "phone": phoneNumber,
    });


    return request.send().then((streamResponse) {
      return http.Response.fromStream(streamResponse);
    }).then((response) {
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return UpdateProfileModel.fromJson(jsonData);
      } else {
        throw Exception("Update failed: ${response.statusCode}");
      }
    }).catchError((error) {
      throw Exception("Request failed: $error");
    });
  }

}
