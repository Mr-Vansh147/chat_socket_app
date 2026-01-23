import 'package:chat_socket_practice/controller/home/tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget tabButton({
  required String title,
  required int index,
  required bool isSelected,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: () => Get.find<TabButtonController>().onChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
