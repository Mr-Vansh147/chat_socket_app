import 'dart:io';

import 'package:chat_socket_practice/config/exception_helper.dart';
import 'package:chat_socket_practice/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';

import '../../repository/group_repo.dart';
import '../../services/image_picker_service.dart';

class GroupCreateController extends GetxController {
  final GroupRepo repository = GroupRepo();

  bool isDetailsFill = false;

  bool validateForm(GlobalKey<FormState> formKey) {
    isDetailsFill = true;
    update();
    return formKey.currentState!.validate();
  }

  File? selectedGroupImage;
  bool showImagePickerOptions = false;

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> groupRegister({
    required String userId,
    required String groupName,
    required String description,
    required File? profileImage,
    required List<String> members,
  }) async {
    if (profileImage != null) {
      final mimeType = lookupMimeType(profileImage.path);
      const allowedTypes = [
        'image/jpeg',
        'image/png',
        'image/jpg',
        'image/webp',
      ];

      if (mimeType == null || !allowedTypes.contains(mimeType)) {
        Get.snackbar(
          "Invalid Image",
          "Only JPG, PNG, JPEG, WEBP images are allowed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    try {
      isDetailsFill = true;
      update();

      print("groupName: $groupName");
      print("description: $description");
      print("profileImage: ${profileImage?.path}");
      print("members: $members");
      print("userId: $userId");

      final memberIds = members.where((id) => id != userId).toList();

      final response = await repository.createGroup(
        userId: userId,
        groupName: groupName,
        description: description,
        groupImage: profileImage?.path ?? '',
        members: memberIds,
      );

      print("Members Number: ${response?.data?.members?.length}");
      print("status: ${response?.status}");
      print("success: ${response?.success}");
      print("message: ${response?.message}");



      if (response?.success == true) {
        Get.snackbar(
          "Success",
          response!.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          Get.offAll(() => HomeView(userID: userId));
        });
      } else if (response?.status == 400) {
        Get.snackbar(
          "Bad Request",
          response!.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showError("Failed to Create", e.toString());
    } finally {
      isDetailsFill = false;
      update();
    }
  }

  void toggleImagePickerOptions() {
    showImagePickerOptions = !showImagePickerOptions;
    update();
  }

  Future<void> pickGroupImageFromCamera() async {
    final ImagePickerService picker = ImagePickerService();
    final File? image = await picker.pickImageFromCamera();
    if (image != null) {
      selectedGroupImage = image;
      showImagePickerOptions = false;
      update();
    }
  }

  Future<void> pickGroupImageFromGallery() async {
    final ImagePickerService picker = ImagePickerService();
    final File? image = await picker.pickImageFromGallery();
    if (image != null) {
      selectedGroupImage = image;
      showImagePickerOptions = false;
      update();
    }
  }



  void clearField() async {
    groupNameController.clear();
    descriptionController.clear();
    showImagePickerOptions = false;
    selectedGroupImage = null;

    update();
  }
}
