import 'package:chat_socket_practice/model/pass_group_model.dart';
import 'package:chat_socket_practice/view/group/group_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/chat/chat_controller.dart';
import '../../controller/group/group_chat_controller.dart';
import '../../controller/home/home_controller.dart';
import '../chat/widgets/attech_file_sheet.dart';
import '../profile/profile_view.dart';

class GroupChatView extends StatefulWidget {
  final PassGroupModel group;
  const GroupChatView({super.key, required this.group});

  @override
  State<GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  final GroupChatController groupChatController =
      Get.find<GroupChatController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupChatController.setGroupId(widget.group.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue.shade100,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            GetBuilder<HomeController>(
              builder: (controller) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.group.groupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          // GetBuilder<ChatController>(
                          //   builder: (controller) {
                          //     return SizedBox(
                          //       height: 20,
                          //       child: AnimatedSwitcher(
                          //         duration: const Duration(milliseconds: 300),
                          //         transitionBuilder:
                          //             (Widget child, Animation<double> animation) {
                          //           return FadeTransition(
                          //             opacity: animation,
                          //             child: child,
                          //           );
                          //         },
                          //         child: controller.isOtherTyping
                          //             ? Text(
                          //           "Messaging...",
                          //           key: const ValueKey("typing"),
                          //           style: TextStyle(
                          //             color: Colors.black45,
                          //             fontSize: 14,
                          //           ),
                          //         )
                          //             : const SizedBox.shrink(key: ValueKey("empty")),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => GroupProfileView(groupId: widget.group.groupId),
                          transition: Transition.leftToRightWithFade,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              (widget.group.groupImage != null &&
                                  widget.group.groupImage!.isNotEmpty)
                              ? NetworkImage(widget.group.groupImage!)
                              : null,
                          child:
                              (widget.group.groupImage == null ||
                                  widget.group.groupImage!.isEmpty)
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Divider(color: Colors.grey.shade200),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GetBuilder<ChatController>(
                  builder: (controller) {
                    return ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.messages[index];
                        final isMe = msg.senderId == controller.myUserId;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // DATE HEADER
                            if (controller.showMessageHeader(index))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      controller.getMessageDate(msg.createdAt!),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // MESSAGE BUBBLE
                            Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 10,
                                  left: isMe ? 60 : 0,
                                  right: isMe ? 0 : 60,
                                ),
                                padding: msg.messageType == "image"
                                    ? const EdgeInsets.all(6)
                                    : const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.green.shade200
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Builder(
                                  builder: (_) {
                                    switch (msg.messageType) {
                                      case "image":
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            msg.image!,
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const SizedBox(
                                                    width: 200,
                                                    height: 200,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const SizedBox(
                                                    width: 200,
                                                    height: 200,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        );

                                      case "pdf":
                                        return GestureDetector(
                                          onTap: () {
                                            controller.openPdf(msg.image!);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.picture_as_pdf,
                                                color: Colors.red,
                                                size: 32,
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      msg.image!
                                                          .split('/')
                                                          .last,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      "PDF",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                      default:
                                        return Text(
                                          msg.message ?? "",
                                          style: const TextStyle(fontSize: 16),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
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
      // Message input field
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(blue: 4),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey),
                onPressed: () {
                  AttachFileSheet.showBottomSheet(context);
                },
              ),

              Expanded(
                child: TextField(
                  controller: Get.find<ChatController>().messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.green,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    Get.find<ChatController>().sendMessage();
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
