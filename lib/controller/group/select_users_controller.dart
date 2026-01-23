import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/home_repo.dart';
import 'package:chat_socket_practice/model/user_list_model.dart';

class SelectUsersController extends GetxController {
  final HomeRepo repository = HomeRepo();

  int page = 1;
  final int pageSize = 10;
  bool hasMore = true;

  String? currentUserId;

  bool isLoading = false;
  bool isSearching = false;
  bool isPulling = false;
  double pullDistance = 0;

  List<Data?> list = [];
  List<Data> selectedUsers = [];
  String errorMessage = '';

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (scrollController.position.pixels < -80 &&
        !isLoading &&
        !isPulling &&
        currentUserId != null) {
      pullDown();
    }

    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore &&
        currentUserId != null) {
      fetchUsers(loadMore: true);
    }
  }

  void resetUser(String userId) {
    currentUserId = userId;

    page = 1;
    hasMore = true;
    list.clear();
    selectedUsers.clear();
    update();
  }

  Future<void> pullDown() async {
    isPulling = true;

    page = 1;
    hasMore = true;
    list.clear();
    update();

    await fetchUsers(userId: currentUserId);

    isPulling = false;
    update();
  }

  void performSearchUser(String query, String userId) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      final value = query.trim();

      if (value.isEmpty) {
        resetController(userId);
        return;
      }

      isSearching = true;
      page = 1;
      hasMore = true;
      list.clear();
      update();

      fetchUsers(userId: userId);
    });
  }

  Future<void> fetchUsers({String? userId, bool loadMore = false}) async {
    if (isLoading) return;

    if (userId != null && currentUserId != userId) {
      currentUserId = userId;
    }

    if (!loadMore) {
      page = 1;
      hasMore = true;
      list.clear();
    }

    if (currentUserId == null) return;

    isLoading = true;
    update();

    final startTime = DateTime.now();
    try {
      final response = await repository.getUserList(
        id: currentUserId!,
        search: searchController.text,
        page: page,
        pageSize: pageSize,
      );
      print(" page = $page pagesize = $pageSize");

      if (response.length < pageSize) {
        hasMore = false;
      }

      list.addAll(response);
      page++;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;

      if (elapsed < 500) {
        await Future.delayed(Duration(milliseconds: 500 - elapsed));
      }
      isLoading = false;
      isSearching = false;
      update();
    }
  }

  Future<void> resetController(String userId) async {
    page = 1;
    hasMore = true;
    isSearching = false;
    list.clear();
    update();

    await fetchUsers(userId: userId);
  }

  String normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  // isUserSelected
  bool isUserSelected({required String userId}) {
    return selectedUsers.any((user) => user.id == userId);
  }

  //select user
  void toggleUserSelection(Data user) {
    final exists = isUserSelected(userId: user.id!);
    if (exists) {
      selectedUsers.removeWhere((u) => u.id == user.id);
    } else {
      selectedUsers.add(user);
    }
    print("Selected number = ${selectedUsers.length}");
    update();
  }
  void clearField() async {
    searchController.clear();
    selectedUsers.clear();
    update();
  }
}
