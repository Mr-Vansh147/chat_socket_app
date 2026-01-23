class UploadImageModel {
  final bool? success;
  final int? status;
  final String? message;
  final Data? data;

  UploadImageModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  UploadImageModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'status' : status,
    'message' : message,
    'data' : data?.toJson()
  };
}

class Data {
  final String? chatImageURL;

  Data({
    this.chatImageURL,
  });

  Data.fromJson(Map<String, dynamic> json)
      : chatImageURL = json['chatImageURL'] as String?;

  Map<String, dynamic> toJson() => {
    'chatImageURL' : chatImageURL
  };
}