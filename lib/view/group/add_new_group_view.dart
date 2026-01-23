import 'package:chat_socket_practice/controller/group/select_users_controller.dart';
import 'package:chat_socket_practice/view/group/widgets/image_select_option_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/group/group_create_controller.dart';

class AddNewGroup extends StatefulWidget {
  final String userID;

  const AddNewGroup({super.key, required this.userID});

  @override
  State<AddNewGroup> createState() => _AddNewGroupState();
}

class _AddNewGroupState extends State<AddNewGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GroupCreateController controller = Get.find<GroupCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.clearField();
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "New Group",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: GetBuilder<GroupCreateController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // pick Image
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: controller.toggleImagePickerOptions,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage:
                                        controller.selectedGroupImage != null
                                        ? FileImage(
                                            controller.selectedGroupImage!,
                                          )
                                        : null,
                                    child: controller.selectedGroupImage == null
                                        ? const Icon(Icons.camera_alt, size: 30)
                                        : null,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              AnimatedSize(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: controller.showImagePickerOptions
                                    ? ClipRect(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ImageSelectOptionBox(
                                                icon: Icons.camera_alt,
                                                label: "Camera",
                                                color: Colors.green,
                                                onTap: controller
                                                    .pickGroupImageFromCamera,
                                              ),
                                              const SizedBox(width: 20),
                                              ImageSelectOptionBox(
                                                icon: Icons.photo_library,
                                                label: "Gallery",
                                                color: Colors.blue,
                                                onTap: controller
                                                    .pickGroupImageFromGallery,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          //first name
                          Text(
                            'Group Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          TextFormField(
                            controller: controller.groupNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'fill Group-Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter Group Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          //Description
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          TextFormField(
                            maxLines: 3,
                            controller: controller.descriptionController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter description';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          Text(
                            'Selected Users',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          // selected users
                          SizedBox(
                            height: 95,
                            child: GetBuilder<SelectUsersController>(
                              builder: (controller) {
                                if (controller.selectedUsers.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No Users Selected',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.selectedUsers.length,
                                  itemBuilder: (context, index) {
                                    final user =
                                        controller.selectedUsers[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage:
                                                user.profileImage?.isNotEmpty ==
                                                    true
                                                ? NetworkImage(
                                                    controller
                                                        .normalizeImageUrl(
                                                          user.profileImage,
                                                        ),
                                                  )
                                                : null,
                                            child:
                                                user.profileImage?.isEmpty ==
                                                    true
                                                ? const Icon(Icons.person)
                                                : null,
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              user.firstName ?? '',
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),

                          // create group
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: .infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  if (!controller.validateForm(_formKey)) return;

                                  final memberIds = Get.find<SelectUsersController>()
                                      .selectedUsers
                                      .map((user) => user.id!)
                                      .where((id) => id != widget.userID)
                                      .toList();

                                  controller.groupRegister(
                                    userId: widget.userID,
                                    groupName: controller.groupNameController.text,
                                    description: controller.descriptionController.text,
                                    profileImage: controller.selectedGroupImage,
                                    members: memberIds,
                                  );
                                },

                                child: Text(
                                  'Create Group',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.6,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
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
