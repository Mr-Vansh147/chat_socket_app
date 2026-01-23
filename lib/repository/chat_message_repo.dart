import 'dart:convert';

import 'package:chat_socket_practice/config/api_end_points.dart';
import 'package:chat_socket_practice/model/chat_message_model.dart';
import 'package:chat_socket_practice/model/upload_image_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class ChatMessageRepo {
  Future<ChatMessageModel?> getMessages({
    required String senderId,
    required String receiverId,
  }) {
    final url = Uri.parse(
      ApiEndPoints.getMessages(senderId: senderId, receiverId: receiverId),
    );
    return http
        .get(url, headers: {"Content-Type": "application/json"})
        .then((response) {
          print("BODY: ${response.body}");

          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            return ChatMessageModel.fromJson(jsonData);
          } else {
            throw Exception("Error: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Request failed: $error");
        });
  }

  Future<UploadImageModel?> uploadFile({required String filePath}) async {
    final url = Uri.parse(ApiEndPoints.uploadImage());
    final request = http.MultipartRequest('POST', url);

    final extension = path.extension(filePath).toLowerCase();

    MediaType mediaType;

    if (extension == '.pdf') {
      mediaType = MediaType('application', 'pdf');
    } else if (extension == '.png') {
      mediaType = MediaType('image', 'png');
    } else {
      mediaType = MediaType('image', 'jpeg');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        filePath,
        contentType: mediaType,
      ),
    );

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return UploadImageModel.fromJson(jsonData);
    } else {
      throw Exception("Upload failed: ${response.statusCode}");
    }
  }
}
