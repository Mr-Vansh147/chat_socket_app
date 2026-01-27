import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/group_members_model.dart';
import '../../model/update_group_profile_model.dart';
import '../../repository/group_repo.dart';
import '../auth/auth_controller.dart';

class GroupProfileController extends GetxController {
  final GroupRepo repository = GroupRepo();

  bool isLoading = false;
  String errorMessage = '';
  GroupMembersModel? groupProfile;
  UpdateGroupProfileModel? updateGroup;
  String? changeImage;

  String get displayImage =>
      changeImage ??
          groupProfile?.data?.image ??
          '';

  void setUpdatedGroupImage(String imageUrl) {
    changeImage = imageUrl;
    update();
  }


  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  bool get isAdmin {
    final myUserId = Get.find<AuthController>().userId;

    return groupProfile?.data?.members?.any(
          (member) =>
      member.userId == myUserId &&
          member.role == 'admin',
    ) ??
        false;
  }


  Timer? debounce;

  void fetchGroupProfile(String id) {
    isLoading = true;
    errorMessage = '';
    update();
    repository
        .groupProfile(groupId: id)
        .then((result) {
      print('GROUP API DATA => ${result?.data}');
          groupProfile = result;
          groupNameController.text = groupProfile?.data?.name ?? '';
          descriptionController.text = groupProfile?.data?.description ?? '';

          update();
        })
        .catchError((error) {
          errorMessage = error.toString();
        })
        .whenComplete(() {
          isLoading = false;
          update();
        });
  }

  Future<void> updateGroupProfile({
    required String userId,
    required String groupId,
    String? groupName,
    String? description,
    String? image,
    List<String>? members,
  }) async {
    isLoading = true;
    update();

    try {
      final response = await repository.updateGroupProfile(
        userId: userId,
        groupId: groupId,
        groupName: groupName,
        description: description,
        groupImage: image,
        members: members,
      );

      if (response.data == null) {
        throw Exception('Failed to update group profile');
      }
      updateGroup = response.data as UpdateGroupProfileModel?;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }
}
