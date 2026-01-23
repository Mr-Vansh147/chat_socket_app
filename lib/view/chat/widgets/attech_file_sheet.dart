import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat/chat_controller.dart';
import '../../../controller/chat/image_controller.dart';

class AttachFileSheet {
  static void showBottomSheet(BuildContext context) {
    final ImageController imageController = Get.find<ImageController>();
    final ChatController chatController = Get.find<ChatController>();

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

                  final imageUrl =
                  await imageController.pickAndUploadFromGallery();

                  if (imageUrl != null) {
                    chatController.sendFinalImageMessage(imageUrl);
                  }
                },
              ),

              // CAMERA
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Camera"),
                onTap: () async {
                  Get.back();

                  final imageUrl =
                  await imageController.pickAndUploadFromCamera();

                  if (imageUrl != null) {
                    chatController.sendFinalImageMessage(imageUrl);
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy_outlined, color: Colors.black54),
                title: const Text("Files"),
                onTap: () async {
                  Get.back();

                  final result = await imageController.pickUploadFile();

                  if (result != null) {
                    chatController.sendFile(
                      fileUrl: result["url"]!,
                      fileName: result["name"]!,
                    );
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
