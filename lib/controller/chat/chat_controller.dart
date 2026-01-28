import 'dart:async';

import 'package:chat_socket_practice/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/chat_message_model.dart';
import '../../repository/chat_message_repo.dart';
import '../../services/pref_service.dart';

class ChatController extends GetxController {
  final SocketService socketService = SocketService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final ChatMessageRepo chatMessageRepo = ChatMessageRepo();

  String? myUserId;
  String? receiverId;

  bool isTyping = false;
  bool isOtherTyping = false;
  Timer? typingTimer;

  List<Data> messages = [];

  // Open Pdf
  Future<void> openPdf(String pdfUrl) async {
    final uri = Uri.parse(pdfUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not open PDF");
    }
  }

  // @override
  // void onClose() {
  //   socketService.disconnect();
  //   super.onClose();
  // }

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
    DateTime currentTime = getMessageTime(messages[index].createdAt!);
    DateTime previousTime = getMessageTime(messages[index - 1].createdAt!);
    return currentTime.day != previousTime.day ||
        currentTime.month != previousTime.month ||
        currentTime.year != previousTime.year;
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!scrollController.hasClients) return;
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  Future<void> startChat(String userId) async {
    receiverId = userId;
    myUserId = await PrefService.getUserId();
    if (myUserId == null) return;

    // Connect socket once
    if (!socketService.isConnected) {
      socketService.connect(myUserId!);
    }
    initSocket();
    loadMessagesFromApi();
  }

  Future<void> loadMessagesFromApi() async {
    if (myUserId == null || receiverId == null) return;

    try {
      final response = await chatMessageRepo.getMessages(
        senderId: myUserId!,
        receiverId: receiverId!,
      );

      messages.clear();
      messages.addAll(response?.data ?? []);
      update();
      scrollToBottom();
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  Future<void> initSocket() async {
    myUserId = await PrefService.getUserId();

    if (myUserId == null) {
      print("UserId not found");
      return;
    }
    print("UserId: $myUserId");

    socketService.receiveMessage((data) {
      if (myUserId == null || receiverId == null) return;

      final String sender = data["senderId"];
      final String receiver = data["receiverId"];

      final bool isCurrentChat =
          (sender == receiverId && receiver == myUserId) ||
          (sender == myUserId && receiver == receiverId);

      if (!isCurrentChat) return;

      messages.add(
        Data(
          senderId: sender,
          receiverId: receiver,
          message: data["message"],
          image: data["image"],
          messageType: data["messageType"],
          createdAt: data["createdAt"],
        ),
      );

      update();
      scrollToBottom();
    });

    socketService.onTyping(
      callback: (senderId) {
        if (senderId == receiverId) {
          setTypingStatues(true);
        }
      },
    );

    socketService.onStopTyping(
      callback: (senderId) {
        if (senderId == receiverId) {
          setTypingStatues(false);
        }
      },
    );
  }

  // send text messages
  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;
    if (myUserId == null || receiverId == null) {
      print("UserId or ReceiverId is null");
      return;
    }
    if (!socketService.isConnected) {
      print("Socket not connected");
      return;
    }

    messages.add(
      Data(
        senderId: myUserId,
        receiverId: receiverId,
        message: text,
        messageType: "text",
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    update();
    scrollToBottom();

    socketService.sendMessage(
      senderId: myUserId!,
      receiverId: receiverId!,
      message: text,
      image: null,
      type: "text",
    );

    messageController.clear();
  }

  // send images
  void sendFinalImageMessage(String imageUrl) {
    if (myUserId == null || receiverId == null) return;
    if (!socketService.isConnected) return;

    messages.add(
      Data(
        senderId: myUserId,
        receiverId: receiverId,
        message: null,
        image: imageUrl,
        messageType: "image",
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    update();
    scrollToBottom();

    socketService.sendMessage(
      senderId: myUserId!,
      receiverId: receiverId!,
      message: null,
      image: imageUrl,
      type: "image",
    );
  }

  // send File
  void sendFile({required String fileUrl, required String fileName}) {
    if (myUserId == null || receiverId == null) return;
    if (!socketService.isConnected) return;

    messages.add(
      Data(
        senderId: myUserId,
        receiverId: receiverId,
        image: fileUrl,
        messageType: "pdf",
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    update();
    scrollToBottom();

    socketService.sendMessage(
      senderId: myUserId!,
      receiverId: receiverId!,
      image: fileUrl,
      type: "pdf",
    );
  }

  //set typing status
  void setTypingStatues(bool value) {
    if (isOtherTyping == value) return;
    isOtherTyping = value;
    update();
  }

  // emit calling while writing
  void writeMessage(String text) {
    const duration = Duration(milliseconds: 1000);

    if (myUserId == null || receiverId == null) return;
    if (!socketService.isConnected) return;

    if (text.isNotEmpty && !isTyping) {
      isTyping = true;
      socketService.emitTyping(senderId: myUserId!, receiverId: receiverId!);
    }

    typingTimer?.cancel();

    typingTimer = Timer(duration, () {
      if (isTyping) {
        isTyping = false;
        socketService.emitStopTyping(
          senderId: myUserId!,
          receiverId: receiverId!,
        );
      }
    });
  }

  void onLogout() {
    myUserId = null;
    receiverId = null;
    messages.clear();
    messageController.clear();
    socketService.disconnect();
    update();
  }
}
