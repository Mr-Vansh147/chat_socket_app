class ChatMessageModel {
  final bool? success;
  final List<Data>? data;

  ChatMessageModel({
    this.success,
    this.data,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'success' : success,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? message;
  final String? image;
  final String? messageType;
  final bool? isRead;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.image,
    this.messageType,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        senderId = json['senderId'] as String?,
        receiverId = json['receiverId'] as String?,
        message = json['message'] as String?,
        image = json['image'] as String?,
        messageType = json['messageType'] as String?,
        isRead = json['isRead'] as bool?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'senderId' : senderId,
    'receiverId' : receiverId,
    'message' : message,
    'image' : image,
    'messageType' : messageType,
    'isRead' : isRead,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}