import 'package:chat_socket_practice/controller/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/group/group_profile_controller.dart';

class GroupProfileView extends StatefulWidget {
  final String groupId;
  const GroupProfileView({super.key, required this.groupId});

  @override
  State<GroupProfileView> createState() => _GroupProfileViewState();
}

class _GroupProfileViewState extends State<GroupProfileView> {
  @override
  void initState() {
    final GroupProfileController controller =
        Get.find<GroupProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fetchGroupProfile(widget.groupId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: GetBuilder<GroupProfileController>(
        builder: (controller) {
          final group = controller.groupProfile?.data;
          String imageUrl = group?.image ?? '';
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
                          "${group?.name}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.6,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "${group?.description}",
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
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Total Members: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "${group?.members?.length}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: group?.members?.length,
                            itemBuilder: (context, index) {
                              final member = group?.members?[index];
                              final imageUrl = Get.find<HomeController>()
                                  .normalizeImageUrl(member?.profileImage);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: imageUrl.isNotEmpty
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: (group?.image?.isEmpty ?? true)
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(
                                    '${member?.firstName} ${member?.lastName}',
                                  ),
                                  subtitle: Text(member?.email ?? ''),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
