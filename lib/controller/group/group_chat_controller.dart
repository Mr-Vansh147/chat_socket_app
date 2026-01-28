import 'dart:async';

import 'package:chat_socket_practice/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/chat_message_model.dart';
import '../../repository/chat_message_repo.dart';
import '../../services/pref_service.dart';

class GroupChatController extends GetxController {
  final SocketService socketService = SocketService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollGroupChatController = ScrollController();
  final ChatMessageRepo chatMessageRepo = ChatMessageRepo();

  String? myUserId;
  String? groupId;

  bool isTyping = false;
  bool isOtherTyping = false;
  Timer? typingTimer;

  List<Data> groupMessages = [];

  Future<void> startGroupChat(String id) async {
    if (groupId == id && socketService.isConnected) {
      return;
    }
    groupId = id;
    myUserId = await PrefService.getUserId();
    if (myUserId == null) return;
    groupMessages.clear();
    update();

    if (!socketService.isConnected) {
      socketService.connect(myUserId!);
      // wait for socket connection
      while (!socketService.isConnected) {
        await Future.delayed(Duration(milliseconds: 50));
      }
    }
    socketService.joinGroup(groupId!);
    initGroupSocket();
    // loadGroupMessagesFromApi();
  }

  // Open Pdf
  Future<void> openPdf(String pdfUrl) async {
    final uri = Uri.parse(pdfUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not open PDF");
    }
  }

  // convert into local time
  DateTime getMessageTime(String createAt) {
    return DateTime.parse(createAt).toLocal();
  }

  // compare with today, yesterday
  String getMessageDate(String createdAt) {
    final messageTime = getMessageTime(createdAt);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      messageTime.year,
      messageTime.month,
      messageTime.day,
    );

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${messageDate.day}/${messageDate.month}/${messageDate.year}';
    }
  }

  //show message Header
  bool showMessageHeader(int index) {
    if (index == 0) return true;
    DateTime currentTime = getMessageTime(groupMessages[index].createdAt!);
    DateTime previousTime = getMessageTime(groupMessages[index - 1].createdAt!);
    return currentTime.day != previousTime.day ||
        currentTime.month != previousTime.month ||
        currentTime.year != previousTime.year;
  }

  void scrollToBottom() {
    if (!scrollGroupChatController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollGroupChatController.jumpTo(
        scrollGroupChatController.position.maxScrollExtent,
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!scrollGroupChatController.hasClients) return;
        scrollGroupChatController.animateTo(
          scrollGroupChatController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  // Future<void> loadGroupMessagesFromApi() async {
  //   if (myUserId == null || groupId == null) return;
  //
  //   try {
  //     final response = await chatMessageRepo.getMessages(
  //       senderId: myUserId!,
  //       receiverId: groupId!,
  //     );
  //
  //     messages.clear();
  //     messages.addAll(response?.data ?? []);
  //     update();
  //     scrollToBottom();
  //   } catch (e) {
  //     print("Error loading messages: $e");
  //   }
  // }

  Future<void> initGroupSocket() async {
    myUserId = await PrefService.getUserId();
    if (myUserId == null || groupId == null) return;

    // socketService.joinGroup(
    //   groupId!,
    // );

    socketService.receiveGroupMessage((data) {
      final String senderId = data["senderId"];
      final String incomingGroupId = data["groupId"];

      if (incomingGroupId != groupId) return;
      if (senderId == myUserId) return;
      groupMessages.add(
        Data(
          senderId: senderId,
          receiverId: incomingGroupId,
          message: data["message"],
          // image: data["image"],
          // messageType: data["messageType"],
          // createdAt: data["createdAt"],
        ),
      );

      update();
      scrollToBottom();
    });
  }

  // send text messages
  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty || myUserId == null || groupId == null) return;

    groupMessages.add(
      Data(
        senderId: myUserId,
        receiverId: groupId,
        message: text,
        messageType: "text",
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    update();
    scrollToBottom();

    socketService.sendGroupMessage(
      senderId: myUserId!,
      groupId: groupId!,
      message: text,
    );

    messageController.clear();
  }

  // send images
  // void sendFinalImageMessage(String imageUrl) {
  //   if (myUserId == null || receiverId == null) return;
  //   if (!socketService.isConnected) return;
  //
  //
  //   messages.add(
  //     Data(
  //       senderId: myUserId,
  //       receiverId: receiverId,
  //       message: null,
  //       image: imageUrl,
  //       messageType: "image",
  //       createdAt: DateTime.now().toIso8601String(),
  //     ),
  //   );
  // //
  //   update();
  //   scrollToBottom();
  //
  //   socketService.sendMessage(
  //     senderId: myUserId!,
  //     receiverId: receiverId!,
  //     message: null,
  //     image: imageUrl,
  //     type: "image",
  //   );
  // }

  //send File
  //  void sendFile({
  //    required String fileUrl,
  //    required String fileName,
  //  }) {
  //    if (myUserId == null || receiverId == null) return;
  //    if (!socketService.isConnected) return;
  //
  //    messages.add(
  //      Data(
  //        senderId: myUserId,
  //        receiverId: receiverId,
  //        image: fileUrl,
  //        messageType: "pdf",
  //        createdAt: DateTime.now().toIso8601String(),
  //      ),
  //    );
  //
  //    update();
  //    scrollToBottom();
  //
  //    socketService.sendMessage(
  //      senderId: myUserId!,
  //      receiverId: receiverId!,
  //      image: fileUrl,
  //      type: "pdf",
  //    );
  //  }

  //set typing status
  // void setTypingStatues(bool value){
  //   if(isOtherTyping == value) return;
  //   isOtherTyping = value;
  //   update();
  // }
  //
  // // emit calling while writing
  // void writeMessage(String text) {
  //   const duration = Duration(milliseconds: 1000);
  //
  //   if (myUserId == null || receiverId == null) return;
  //   if (!socketService.isConnected) return;
  //
  //   if (text.isNotEmpty && !isTyping) {
  //     isTyping = true;
  //     socketService.emitTyping(
  //       senderId: myUserId!,
  //       receiverId: receiverId!,
  //     );
  //   }
  //
  //   typingTimer?.cancel();
  //
  //   typingTimer = Timer(duration, () {
  //     if (isTyping) {
  //       isTyping = false;
  //       socketService.emitStopTyping(
  //         senderId: myUserId!,
  //         receiverId: receiverId!,
  //       );
  //     }
  //   });
  // }
  //
  // void onLogout() {
  //   myUserId = null;
  //   receiverId = null;
  //   messages.clear();
  //   messageController.clear();
  //   socketService.disconnect();
  //   update();
  // }
}
