import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/group/group_create_controller.dart';
import '../../controller/group/select_users_controller.dart';
import 'add_new_group_view.dart';

class SelectUsersView extends StatefulWidget {
  final String userID;
  const SelectUsersView({super.key, required this.userID});

  @override
  State<SelectUsersView> createState() => _SelectUsersViewState();
}

class _SelectUsersViewState extends State<SelectUsersView> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<SelectUsersController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetUser(widget.userID);
      controller.fetchUsers(userId: widget.userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Select Users",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      Get.find<GroupCreateController>().clearField();
                      Get.to(
                        () => AddNewGroup(userID:widget.userID,),
                        transition: Transition.leftToRightWithFade,
                      );
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 50,
                child: GetBuilder<SelectUsersController>(
                  builder: (controller) {
                    return SearchBar(
                      controller: controller.searchController,
                      onChanged: (value) {
                        controller.performSearchUser(value, widget.userID);
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
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GetBuilder<SelectUsersController>(
                  builder: (controller) {
                    return ListView.builder(
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount:
                          controller.list.length + (controller.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.list.length) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final user = controller.list[index];
                        final imageUrl = controller.normalizeImageUrl(
                          user?.profileImage,
                        );
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          child: ListTile(
                            onTap: () {
                              controller.toggleUserSelection(user!);
                            },
                            leading: CircleAvatar(
                              backgroundImage: (imageUrl.isNotEmpty)
                                  ? NetworkImage(imageUrl)
                                  : null,
                              child: (user?.profileImage?.isEmpty ?? true)
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text('${user?.firstName} ${user?.lastName}'),
                            subtitle: Text(user?.email ?? ''),
                            trailing:
                                controller.isUserSelected(
                                  userId: user?.id ?? '',
                                )
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.radio_button_unchecked),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
