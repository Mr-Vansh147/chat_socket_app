import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/exception_helper.dart';
import '../../model/user_list_model.dart';
import '../../repository/home_repo.dart';

class UserListController extends GetxController {
  final HomeRepo repository = HomeRepo();

  String? currentUserId;
  Timer? debounce;

  int page = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoading = false;
  bool isLoadMore = false;
  bool isSearching = false;
  bool isPulling = false;

  List<Data?> list = [];

  final ScrollController userScrollController = ScrollController();

  Timer? debounceTimer;

  @override
  void onInit() {
    super.onInit();
    userScrollController.addListener(onScroll);
  }

  void onScroll() {
    if (userScrollController.position.pixels < -80 &&
        !isLoading &&
        !isPulling &&
        currentUserId != null) {
      onPullDown();
    }

    if (userScrollController.position.pixels >=
        userScrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      fetchUserList(loadMore: true);
    }
  }

  Future<void> onPullDown() async {
    isPulling = true;
    page = 1;
    hasMore = true;
    list.clear();
    update();

    await fetchUserList(userId: currentUserId);
    isPulling = false;
    update();
  }

  Future<void> fetchUserList({
    String? userId,
    bool loadMore = false,
    String? search,
    bool reset = false,
  }) async {
    debounceTimer?.cancel();

    debounceTimer = Timer(const Duration(milliseconds: 200), () async {
      if (loadMore) {
        if (isLoadMore || !hasMore) return;
      } else {
        if (isLoading) return;
      }

      if (userId != null) currentUserId = userId;
      if (currentUserId == null) return;

      if (reset) {
        page = 1;
        hasMore = true;
        list.clear();
      }

      if (!loadMore) {
        isLoading = true;
      } else {
        isLoadMore = true;
      }

      update();

      try {
        final response = await repository.getUserList(
          id: currentUserId!,
          search: search ?? '',
          page: page,
          pageSize: pageSize,
        );

        if (response.length < pageSize) {
          hasMore = false;
        }

        list.addAll(response);
        page++;
      } catch (e) {
        showError("Error", e.toString());
      } finally {
        isLoading = false;
        isLoadMore = false;
        isSearching = false;
        update();
      }
    });
  }


  Future<void> reset(String userId) async {
    page = 1;
    hasMore = true;
    isSearching = false;
    list.clear();
    update();

    await fetchUserList(userId: userId);
  }

  void onLogout() {
    currentUserId = null;
    page = 1;
    hasMore = true;
    isLoading = false;
    isSearching = false;
    isPulling = false;
    list.clear();
    update();
  }
}
