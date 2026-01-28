import 'package:chat_socket_practice/controller/home/home_controller.dart';
import 'package:chat_socket_practice/view/chat/widgets/attech_file_sheet.dart';
import 'package:chat_socket_practice/view/profile/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat/chat_controller.dart';
import '../../model/passUserModel.dart';

class ChatView extends StatefulWidget {
  final PassUserModel user;

  const ChatView({super.key, required this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    final ChatController chatController = Get.find<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.startChat(widget.user.id);
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
            GetBuilder<HomeController>(
              builder: (controller) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.socketService.disconnect();
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => UserProfileView(userID: widget.user.id),
                          transition: Transition.leftToRightWithFade,
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            (widget.user.image != null &&
                                widget.user.image!.isNotEmpty)
                            ? NetworkImage(widget.user.image!)
                            : null,
                        child:
                            (widget.user.image == null ||
                                widget.user.image!.isEmpty)
                            ? const Icon(Icons.person)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          Text(
                            widget.user.email ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GetBuilder<ChatController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            height: 20,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                              child: controller.isOtherTyping
                                  ? Text(
                                      "(Messaging)",
                                      key: const ValueKey("typing"),
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                      ),
                                    )
                                  : const SizedBox.shrink(
                                      key: ValueKey("empty"),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert_outlined, color: Colors.black),
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
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18,
        ),
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
                  onChanged: (value) {
                    Get.find<ChatController>().writeMessage(value);
                  },
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
