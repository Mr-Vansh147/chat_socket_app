import 'package:chat_socket_practice/controller/home/home_controller.dart';
import 'package:chat_socket_practice/view/group/group_chat_view.dart';
import 'package:chat_socket_practice/view/group/widgets/image_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth/auth_controller.dart';
import '../../controller/group/group_profile_controller.dart';
import '../../controller/group/select_users_controller.dart';
import '../../model/pass_group_model.dart';

class UpdateGroupView extends StatefulWidget {
  final String groupId;

  const UpdateGroupView({super.key, required this.groupId});

  @override
  State<UpdateGroupView> createState() => _UpdateGroupViewState();
}

class _UpdateGroupViewState extends State<UpdateGroupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<GroupProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchGroupProfile(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectUsersController = Get.find<SelectUsersController>();

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Update Group Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Form(
                key: _formKey,
                child: GetBuilder<GroupProfileController>(
                  builder: (controller) {
                    // final imageUrl =
                    //     controller.groupProfile?.data?.image?.replaceAll(
                    //       'localhost',
                    //       '10.0.2.2',
                    //     ) ??
                    //     '';
                    final displayImage = controller.displayImage;
                    final group = controller.groupProfile?.data;
                    if (controller.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                               CircleAvatar(
                                radius: 52,
                                backgroundColor: Colors.green.shade200,
                                child: CircleAvatar(
                                  radius: 48,
                                backgroundImage: displayImage.isNotEmpty
                                    ? NetworkImage(displayImage)
                                  : null,

                              child: displayImage.isEmpty
                                      ? const Icon(Icons.group, size: 36)
                                      : null,
                                ),
                              ),
                                if(controller.isAdmin)
                                  Positioned(
                                    bottom: -2,
                                    right: -2,
                                    child: CircleAvatar(
                                      radius: 19,
                                      backgroundColor: Colors.grey.shade50,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(
                                          Icons.photo_camera_outlined,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          ImageSelectionSheet.showBottomSheet(context);
                                        },
                                      ),
                                    ),
                                  ),

                      ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Group Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            enabled: controller.isAdmin,
                            controller: controller.groupNameController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter group name'
                                : null,
                            decoration: InputDecoration(
                              suffixIcon: controller.isAdmin
                                  ? Icon(Icons.lock_open_outlined)
                                  : Icon(Icons.lock_outline),
                              hintText: 'Group name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            enabled: controller.isAdmin,
                            maxLines: 3,
                            controller: controller.descriptionController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter description'
                                : null,
                            decoration: InputDecoration(
                              suffixIcon: controller.isAdmin
                                  ? Icon(Icons.lock_open_outlined)
                                  : Icon(Icons.lock_outline),
                              hintText: 'enter your First name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Members',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            height: 95,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: group?.members?.length,
                              itemBuilder: (context, index) {
                                final member = group?.members?[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          CircleAvatar(
                                            radius: 35,
                                            backgroundImage: member?.profileImage?.isNotEmpty == true
                                                ? NetworkImage(
                                              Get.find<HomeController>()
                                                  .normalizeImageUrl(member?.profileImage),
                                            )
                                                : null,
                                            child: member?.profileImage?.isEmpty == true
                                                ? const Icon(Icons.person)
                                                : null,
                                          ),
                                          if(controller.isAdmin)
                                          Positioned(
                                            bottom: -2,
                                            right: -2,
                                            child: CircleAvatar(
                                              radius: 14,
                                              backgroundColor: Colors.green.shade50,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  // controller.removeMember(
                                                  //   groupId: widget.groupId,
                                                  //   memberId: member?.sId,
                                                  // );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          member?.firstName ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isAdmin
                                    ? Colors.green
                                    : Colors.grey.shade400,
                              ),
                              onPressed: controller.isAdmin
                                  ? () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                controller.updateGroupProfile(
                                  userId:
                                  Get
                                      .find<AuthController>()
                                      .userId!,
                                  groupId: widget.groupId,
                                  groupName:
                                  controller.groupNameController.text,
                                  description: controller
                                      .descriptionController
                                      .text,
                                  members: selectUsersController
                                      .selectedUsers
                                      .map((user) => user.id!)
                                      .toList(),
                                  image: displayImage,
                                );
                                final group = PassGroupModel(
                                  groupId: widget.groupId,
                                  groupName:  controller.groupNameController.text,
                                  groupImage: displayImage,
                                  groupDescription: controller
                                      .descriptionController
                                      .text,
                                );
                                  Get.offAll(() => GroupChatView(group: group));
                              }
                                  : null,
                              child: Text(
                                controller.isAdmin ? 'Update' : 'Admin Only',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: controller.isAdmin
                                      ? Colors.black
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
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
