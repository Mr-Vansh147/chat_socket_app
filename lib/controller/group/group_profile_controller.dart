import 'dart:async';

import 'package:chat_socket_practice/controller/group/select_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/group_members_model.dart' as gm;
import '../../model/update_group_profile_model.dart' hide Data;
import '../../repository/group_repo.dart';
import '../auth/auth_controller.dart';
import '../../model/user_list_model.dart';

class GroupProfileController extends GetxController {
  final GroupRepo repository = GroupRepo();

  bool isLoading = false;
  String errorMessage = '';
  gm.GroupMembersModel? groupProfile;
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

    repository.groupProfile(groupId: id).then((result) {
      groupProfile = result;
      groupNameController.text = groupProfile?.data?.name ?? '';
      descriptionController.text = groupProfile?.data?.description ?? '';

      final selectController = Get.find<SelectUsersController>();

      selectController.selectedUsers =
          (groupProfile?.data?.members ?? [])
              .map<Data>((m) => Data(id: m.userId))
              .toList();

    }).catchError((error) {
      errorMessage = error.toString();
    }).whenComplete(() {
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
      errorMessage = '';
      updateGroup = response;

    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> removeMemberFromGroup({
    required String adminId,
    required String groupId,
    required String memberId,
  }) async {
    isLoading = true;
    update();

    try {
      if (adminId == memberId) {
        throw Exception("Admin can't remove himself");
      }

      final updatedMembers = (groupProfile?.data?.members ?? [])
          .map((m) => m.userId!)
          .where((id) => id != memberId)
          .toList();

      await repository.updateGroupProfile(
        userId: adminId,
        groupId: groupId,
        groupName: groupNameController.text,
        description: descriptionController.text,
        groupImage: changeImage ?? groupProfile?.data?.image,
        members: updatedMembers,
      );

      groupProfile?.data?.members
          ?.removeWhere((m) => m.userId == memberId);

      final selectController = Get.isRegistered<SelectUsersController>()
          ? Get.find<SelectUsersController>()
          : null;

      selectController?.selectedUsers
          .removeWhere((u) => u.id == memberId);

    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

}
