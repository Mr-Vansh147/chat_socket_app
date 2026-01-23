import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  FilePickerService._internal();

  static final FilePickerService instance =
  FilePickerService._internal();

  factory FilePickerService() => instance;

  Future<File?> pickSingleFile({
    FileType type = FileType.any,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    return File(result.files.single.path!);
  }
}
