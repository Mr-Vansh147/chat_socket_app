class RegisterModel {
  final bool? success;
  final int? status;
  final String? message;
  final Data? data;

  RegisterModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  RegisterModel.fromJson(Map<String, dynamic> json)
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
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final String? password;
  final String? profileImage;
  final bool? isOnline;
  final String? id;
  final String? lastSeen;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.profileImage,
    this.isOnline,
    this.id,
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] as String?,
        lastName = json['lastName'] as String?,
        email = json['email'] as String?,
        countryCode = json['countryCode'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        password = json['password'] as String?,
        profileImage = json['profileImage'] as String?,
        isOnline = json['isOnline'] as bool?,
        id = json['_id'] as String?,
        lastSeen = json['lastSeen'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    'firstName' : firstName,
    'lastName' : lastName,
    'email' : email,
    'countryCode' : countryCode,
    'phoneNumber' : phoneNumber,
    'password' : password,
    'profileImage' : profileImage,
    'isOnline' : isOnline,
    '_id' : id,
    'lastSeen' : lastSeen,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}