import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

void showError(String title, dynamic error) {
  String message = "Something went wrong";

  try {
    //  Map error (already decoded JSON)
    if (error is Map) {
      message = error['message'] ?? message;
    }


    // JSON string
    else if (error is String && error.startsWith('{')) {
      final decoded = jsonDecode(error);
      message = decoded['message'] ?? message;
    }

    // Fallback
    else {
      message = error.toString().replaceFirst('Exception: ', '');
    }
  } catch (_) {
    message = error.toString();
  }

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}
