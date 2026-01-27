import 'dart:convert';

import 'package:chat_socket_practice/model/group_list_model.dart';
import 'package:chat_socket_practice/model/update_group_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import '../config/api_end_points.dart';
import '../config/exception_helper.dart';
import '../model/group_members_model.dart';
import '../model/new_group_model.dart';

class GroupRepo {
  // create Group
  Future<NewGroupModel?> createGroup({
    required String userId,
    required String groupName,
    required String description,
    required String groupImage,
    required List<String> members,
  }) async {
    try {
      final uri = Uri.parse(ApiEndPoints.newGroup());
      final request = http.MultipartRequest('POST', uri);

      // Text fields
      request.fields.addAll({
        'userId': userId,
        'name': groupName,
        'description': description,
      });

      for (final id in members.where((id) => id != userId)) {
        request.files.add(http.MultipartFile.fromString('members[]', id));
      }

      // Image
      final extension = path.extension(groupImage).toLowerCase();

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
          groupImage,
          contentType: mediaType,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NewGroupModel.fromJson(jsonDecode(responseBody));
      } else {
        showError("Failed to Create", responseBody);
      }
    } catch (e) {
      showError("Error", e.toString());
    }

    return null;
  }

  // group list
  Future<GroupListModel?> groupList({
    required String userId,
    String? search = '',
    int? page,
    int? pageSize,
  }) async {
    try {
      final url = Uri.parse(
        ApiEndPoints.getGroupList(
          id: userId,
          search: search,
          page: page.toString(),
          pageSize: pageSize.toString(),
        ),
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return GroupListModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      showError("Error", e.toString());
    }
    return null;
  }

  Future<GroupMembersModel?> groupProfile({required String groupId}) async {
    try {
      final url = Uri.parse(ApiEndPoints.groupProfile(groupId: groupId));
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return GroupMembersModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<UpdateGroupProfileModel> updateGroupProfile({
    required String userId,
    required String groupId,
    String? groupName,
    String? description,
    String? groupImage,
    List<String>? members,
  }) async {
    final url = Uri.parse(
      ApiEndPoints.updateGroupProfile(userId: userId, groupId: groupId),
    );
    final request = http.MultipartRequest('PUT', url);

    request.fields.addAll({
      "userId": userId,
      "name": groupName ?? '',
      "description": description ?? '',
      "groupId": groupId,
    });
    for (final id in members!.where((id) => id != userId)) {
      request.files.add(http.MultipartFile.fromString('members[]', id));
    }
    if (groupImage != null &&
        groupImage.isNotEmpty &&
        !groupImage.startsWith('http')) {

      final extension = path.extension(groupImage).toLowerCase();

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
          groupImage,
          contentType: mediaType,
        ),
      );
    }
    return request
        .send()
        .then((streamResponse) {
          return http.Response.fromStream(streamResponse);
        })
        .then((response) {
          print("BODY: ${response.body}");

          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            return UpdateGroupProfileModel.fromJson(jsonData);
          } else {
            throw Exception("Update failed: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Request failed: $error");
        });
  }
}
