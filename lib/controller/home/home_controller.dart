import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_list_controller.dart';
import 'group_list_controller.dart';

class HomeController extends GetxController {
  final UserListController userCtrl = Get.find<UserListController>();
  final GroupListController groupCtrl = Get.find<GroupListController>();

  final TextEditingController searchController = TextEditingController();
  Timer? debounce;

  String? currentUserId;
  bool isSearching = false;

  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void init(String userId) {
    currentUserId = userId;
  }

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      final value = query.trim();

      if (value.isEmpty) {
        resetSearch();
      } else {
        performSearch();
      }
    });
  }

  Future<void> performSearch() async {
    if (currentUserId == null) return;

    isSearching = true;
    update();

    await Future.wait([
      userCtrl.fetchUserList(
        userId: currentUserId!,
        search: searchController.text,
        reset: true,
      ),
      groupCtrl.fetchGroupList(
        userId: currentUserId!,
        search: searchController.text,
        reset: true,
      ),
    ]);

    isSearching = false;
    update();
  }

  Future<void> resetSearch() async {
    if (currentUserId == null) return;

    searchController.clear();
    isSearching = true;
    update();

    await Future.wait([
      userCtrl.onPullDown(),
      groupCtrl.onPullDown(),
    ]);

    isSearching = false;
    update();
  }

  String normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('localhost')) return url.replaceAll('localhost', '10.0.2.2');
    return url;
  }

  // Logout
  void onLogout() {
    searchController.clear();
    isSearching = false;
    currentUserId = null;

    userCtrl.onLogout();
    groupCtrl.onLogout();

    update();
  }
}
