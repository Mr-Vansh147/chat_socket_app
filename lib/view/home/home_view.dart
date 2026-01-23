import 'package:chat_socket_practice/controller/home/home_controller.dart';
import 'package:chat_socket_practice/model/passUserModel.dart';
import 'package:chat_socket_practice/view/home/widgets/tab_button.dart';
import 'package:chat_socket_practice/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth/auth_controller.dart';
import '../../controller/home/group_list_controller.dart';
import '../../controller/home/tab_controller.dart';
import '../../controller/home/user_list_controller.dart';
import '../../model/pass_group_model.dart';
import '../chat/chat_view.dart';
import '../group/group_chat_view.dart';
import '../group/select_users_view.dart';

class HomeView extends StatefulWidget {
  final String userID;

  const HomeView({super.key, required this.userID});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final homeCtrl = Get.find<HomeController>();
    final userCtrl = Get.find<UserListController>();
    final groupCtrl = Get.find<GroupListController>();
    homeCtrl.init(widget.userID);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userCtrl.fetchUserList(userId: widget.userID, reset: true);
      groupCtrl.fetchGroupList(userId: widget.userID, reset: true);
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: Padding(
          padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              GetBuilder<AuthController>(
                builder: (controller) {
                  final imageUrl = controller.normalizeImageUrl(
                    controller.userProfileImage,
                  );

                  return Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hello, ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: controller.userFirstName,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => SelectUsersView(userID: controller.userId!),
                            transition: Transition.leftToRightWithFade,
                          );
                        },
                        icon: Icon(
                          Icons.group_add_outlined,
                          color: Colors.green.shade700,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),

                      GestureDetector(
                        onTap: () {
                          Get.to(() => ProfileView(userID: controller.userId!));
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 15),

              // search bar
              SizedBox(
                height: 50,
                child: GetBuilder<HomeController>(
                  builder: (controller) {
                    return SearchBar(
                      autoFocus: false,
                      controller: controller.searchController,
                      onChanged: (value) {
                        controller.onSearchChanged(value);
                      },
                      backgroundColor: WidgetStateProperty.all(
                        Colors.lightBlue.shade50,
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: WidgetStateProperty.all(1),
                      leading: Icon(
                        Icons.search,
                        color: Colors.black45,
                        size: 30,
                      ),
                      hintText: 'Search',
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: GetBuilder<TabButtonController>(
                  builder: (controller) {
                    return Row(
                      children: [
                        tabButton(
                          title: "Chats",
                          index: 0,
                          isSelected: controller.currentIndex == 0,
                        ),
                        tabButton(
                          title: "Groups",
                          index: 1,
                          isSelected: controller.currentIndex == 1,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: GetBuilder<TabButtonController>(
                  builder: (tab) {
                    if (tab.currentIndex == 0) {
                      return GetBuilder<UserListController>(
                        builder: (controller) {
                          return ListView.builder(
                            shrinkWrap: true,
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount:
                                controller.list.length +
                                (controller.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.list.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final user = controller.list[index];
                              final imageUrl = Get.find<HomeController>()
                                  .normalizeImageUrl(user?.profileImage);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    final chatUser = PassUserModel(
                                      id: user!.id!,
                                      name:
                                          '${user.firstName} ${user.lastName}',
                                      image: user.profileImage,
                                      email: user.email,
                                    );
                                    Get.to(() => ChatView(user: chatUser));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: (imageUrl.isNotEmpty)
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: (user?.profileImage?.isEmpty ?? true)
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),

                                  title: Text(
                                    '${user?.firstName} ${user?.lastName}',
                                  ),
                                  subtitle: Text(user?.email ?? ''),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return GetBuilder<GroupListController>(
                        builder: (controller) {
                          return ListView.builder(
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: EdgeInsets.zero,
                            itemCount:
                                controller.groupList.length +
                                (controller.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.groupList.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final group = controller.groupList[index];
                              final imageUrl = Get.find<HomeController>()
                                  .normalizeImageUrl(group?.image);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    final chatGroup = PassGroupModel(
                                      groupId: group!.sId!,
                                      groupName: group.name!,
                                      groupImage: group.image!,
                                      groupDescription: group.description!,
                                    );
                                    Get.to(
                                      () => GroupChatView(group: chatGroup),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: imageUrl.isNotEmpty
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: (group?.image?.isEmpty ?? true)
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(group?.name ?? ''),
                                  subtitle: Text(group?.description ?? ''),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
