import 'package:chat_socket_practice/config/api_end_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  bool get isConnected => socket != null && socket!.connected;

  void connect(String userId) async{
    if (isConnected) return;
    socket = IO.io(
      ApiEndPoints.socketUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

   socket!.onConnect((_) {
      print("Connected to socket");
      socket!.emit("join", userId);
    });

   socket!.connect();

    socket!.onDisconnect((_) {
      print("Disconnected from socket");
    });
  }

  void disconnect() {
    if (socket != null) {
      socket!.offAny();
      socket!.disconnect();
      socket!.dispose();
      socket = null;
      print("Socket fully disconnected");
    }
  }

  // user send msg
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

  // user receive msg
  void receiveMessage(Function(Map data) onReceiveMessage) {
    socket?.off("receiveMessage");
    socket?.on("receiveMessage", (data) {
      onReceiveMessage(data);
    });
  }

  // join group
  void joinGroup(String groupId) {
    if (!isConnected) return;
    socket!.emit("joinGroup", {"groupId": groupId});
    print("Joined group → $groupId");
  }

  // send msg in group
  void sendGroupMessage({
    required String senderId,
    required String groupId,
    String? message,
    // String? image,
    // String? type,
  }) {
    if (!isConnected) {
      print("Socket not connected");
      return;
    }

    socket!.emit("sendGroupMessage", {
      "payload": {"senderId": senderId, "groupId": groupId, "message": message},
    });

    print("GROUP SEND → sender:$senderId group:$groupId msg:$message ");
  }

  void receiveGroupMessage(Function(Map data) onReceive) {
    socket?.off("receiveGroupMessage");
    socket?.on("receiveGroupMessage", (data) {
      if (data == null) return;
      onReceive(data);
    });
  }

  void emitTyping({required String senderId, required String receiverId}) {
    if (!isConnected || socket == null) return;
    socket!.emit("typing", {"senderId": senderId, "receiverId": receiverId});
  }

  void emitStopTyping({required String senderId, required String receiverId}) {
    if (!isConnected || socket == null) return;
    socket!.emit("stopTyping", {
      "senderId": senderId,
      "receiverId": receiverId,
    });
  }

  void onTyping({required Function(String senderId) callback}) {
    socket?.on("typing", (data) {
      if (data == null) return;
      callback(data["senderId"]);
      print("ON → typing | sender: ${data["senderId"]}");
    });
  }

  void onStopTyping({required Function(String senderId) callback}) {
    socket?.on("stopTyping", (data) {
      if (data == null) return;
      callback(data["senderId"]);
      print("ON → stopTyping | sender: ${data["senderId"]}");
    });
  }
}
