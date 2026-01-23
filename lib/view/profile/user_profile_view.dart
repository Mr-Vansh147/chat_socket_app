import 'package:chat_socket_practice/controller/profile/profile_controller.dart';
import 'package:chat_socket_practice/view/profile/widget/user_details_list_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileView extends StatefulWidget {
  final String userID;
  const UserProfileView({super.key, required this.userID});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {

  @override
  void initState() {
    final ProfileController controller = Get.find<ProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fetchUserProfile(widget.userID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          String imageUrl = controller.profileImageController.text.replaceAll(
            'localhost',
            '10.0.2.2',
          );
          final user = controller.user;
          return Padding(
            padding: const EdgeInsets.only(top: 55),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.green,
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl.isEmpty
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${user?.firstName} ${user?.lastName}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.6,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "${user?.countryCode} ${user?.phoneNumber}",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert_outlined, color: Colors.black),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade200,),
                SizedBox(height: 10,),
                UserDetailsListBox(
                  name: "${user?.firstName} ${user?.lastName}",
                  email: "${user?.email}",
                  phoneNumber: "${user?.countryCode} ${user?.phoneNumber}",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
