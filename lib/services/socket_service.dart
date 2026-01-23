import 'package:chat_socket_practice/config/api_end_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect(String userId) {
    socket = IO.io(
      ApiEndPoints.socketUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket!.onConnect((_) {
      print("Connected to socket");
      socket!.emit("join", userId);
    });

    socket!.onDisconnect((_) {
      print("Disconnected from socket");
    });
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
      print("Socket fully disconnected");
    }
  }

  bool get isConnected => socket != null && socket!.connected;

  // SEND MESSAGE
  void sendMessage({
    required String senderId,
    required String receiverId,
    String? message,
    String? type,
    String? image,
  }) {
    if (!isConnected) {
      print("Socket not connected");
      return;
    }

    socket!.emit("sendMessage", {
      "payload": {
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "image": image,
        "messageType": type,
      },
    });
    print(
      'senderID = $senderId, receiverID = $receiverId, message = $message, type = $type, image = $image',
    );
  }

  void emitTyping({
    required String senderId,
    required String receiverId,
  }) {
    if (!isConnected || socket == null) return;
    socket!.emit("typing", {
      "senderId": senderId,
      "receiverId": receiverId,
    });
  }

  void emitStopTyping({
    required String senderId,
    required String receiverId,
  }) {
    if (!isConnected || socket == null) return;
    socket!.emit("stopTyping", {
      "senderId": senderId,
      "receiverId": receiverId,
    });
  }


  void onTyping({
    required Function(String senderId) callback,
  }) {
    socket?.on("typing", (data) {
      if (data == null) return;
      callback(data["senderId"]);
      print("ON → typing | sender: ${data["senderId"]}");
    });
  }

  void onStopTyping({
    required Function(String senderId) callback,
  }) {
    socket?.on("stopTyping", (data) {
      if (data == null) return;
      callback(data["senderId"]);
      print("ON → stopTyping | sender: ${data["senderId"]}");
    });
  }


  void receiveMessage(Function(Map data) onReceiveMessage) {
    socket?.off("receiveMessage");
    socket?.on("receiveMessage", (data) {
      onReceiveMessage(data);
    });
  }
}
