import 'dart:io';
import 'package:get/get.dart';
import '../../repository/chat_message_repo.dart';
import '../../services/file_picker_service.dart';
import '../../services/image_picker_service.dart';

class ImageController extends GetxController {
  final ImagePickerService pickerService = ImagePickerService();
  final FilePickerService filePickerService = FilePickerService();
  final ChatMessageRepo uploadRepo = ChatMessageRepo();

  bool isUploading = false;

  // GALLERY
  Future<String?> pickAndUploadFromGallery() async {
    try {
      File? image = await pickerService.pickImageFromGallery();
      if (image == null) return null;

      isUploading = true;
      update();

      final result = await uploadRepo.uploadFile(
        filePath: image.path,
      );

      return result?.data?.chatImageURL;
    } catch (e) {
      print("Gallery upload error: $e");
      return null;
    } finally {
      isUploading = false;
      update();
    }
  }

  // CAMERA
  Future<String?> pickAndUploadFromCamera() async {
    try {
      File? image = await pickerService.pickImageFromCamera();
      if (image == null) return null;

      isUploading = true;
      update();

      final result = await uploadRepo.uploadFile(
          filePath : image.path,
      );

      return result?.data?.chatImageURL;
    } catch (e) {
      print("Camera upload error: $e");
      return null;
    } finally {
      isUploading = false;
      update();
    }
  }

  Future<Map<String, String>?> pickUploadFile() async {
    try {
      final File? file = await FilePickerService().pickSingleFile();
      if (file == null) return null;

      final fileName = file.path.split('/').last;
      print("fileName: $fileName");
      print("filePath: ${file.path}");

      final response = await uploadRepo.uploadFile(filePath: file.path);
      final uploadedUrl = response?.data?.chatImageURL;

      if (uploadedUrl == null) return null;

      return {
        "url": uploadedUrl,
        "name": fileName,
      };
    } catch (e) {
      print("upload error: $e");
      return null;
    }
  }





}
