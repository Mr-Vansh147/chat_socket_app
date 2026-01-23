import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/exception_helper.dart';
import '../../model/group_list_model.dart';
import '../../repository/group_repo.dart';

class GroupListController extends GetxController {
  final GroupRepo repository = GroupRepo();

  String? currentUserId;

  int page = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoading = false;

  List<GroupData?> groupList = [];

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (scrollController.position.pixels < -70 &&
        !isLoading &&
        currentUserId != null) {
      onPullDown();
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      fetchGroupList(loadMore: true);
    }
  }

  Future<void> onPullDown() async {
    page = 1;
    hasMore = true;
    groupList.clear();
    update();

    await fetchGroupList(userId: currentUserId);
  }

  Future<void> fetchGroupList({String? userId, bool loadMore = false,
    bool reset = false,
  String? search = ''}) async {
    if (isLoading) return;

    if (userId != null) currentUserId = userId;
    if (currentUserId == null) return;
    if(reset) {
      page = 1;
      hasMore = true;
      groupList.clear();
    }

    if (!loadMore) {
      page = 1;
      hasMore = true;
      groupList.clear();
    }

    isLoading = true;
    update();

    try {
      final response = await repository.groupList(
        userId: currentUserId!,
        search: search,
        page: page,
        pageSize: pageSize,
      );

      final data = response?.data ?? [];

      if (data.length < pageSize) {
        hasMore = false;
      }

      groupList.addAll(data);
      page++;
    } catch (e) {
      showError("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  void onLogout() {
    currentUserId = null;
    page = 1;
    hasMore = true;
    isLoading = false;
    groupList.clear();
    update();
  }
}
