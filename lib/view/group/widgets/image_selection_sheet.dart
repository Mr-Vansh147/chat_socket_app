import 'package:chat_socket_practice/controller/group/group_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/chat/image_controller.dart';

class ImageSelectionSheet {
  static void showBottomSheet(BuildContext context) {
    final ImageController imageController = Get.find<ImageController>();
    final GroupProfileController groupProfileController = Get.find<GroupProfileController>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // GALLERY
              ListTile(
                leading: const Icon(Icons.image, color: Colors.green),
                title: const Text("Gallery"),
                onTap: () async {
                  Get.back();

                  final imageUrl = await imageController
                      .pickAndUploadFromGallery();

                  if (imageUrl != null) {
                    groupProfileController.setUpdatedGroupImage(imageUrl);
                  }
                },
              ),

              // CAMERA
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Camera"),
                onTap: () async {
                  Get.back();

                  final imageUrl = await imageController
                      .pickAndUploadFromCamera();

                  if (imageUrl != null) {
                    groupProfileController.setUpdatedGroupImage(imageUrl);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
