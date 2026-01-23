class UserListModel {
  final bool? success;
  final int? status;
  final String? message;
  final List<Data>? data;
  final Pagination? pagination;

  UserListModel({
    this.success,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  UserListModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList(),
        pagination = (json['pagination'] as Map<String,dynamic>?) != null ? Pagination.fromJson(json['pagination'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList(),
    'pagination' : pagination?.toJson()
  };
}

class Data {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final String? password;
  final String? profileImage;
  final bool? isOnline;
  final String? lastSeen;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.profileImage,
    this.isOnline,
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        firstName = json['firstName'] as String?,
        lastName = json['lastName'] as String?,
        email = json['email'] as String?,
        countryCode = json['countryCode'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        password = json['password'] as String?,
        profileImage = json['profileImage'] as String?,
        isOnline = json['isOnline'] as bool?,
        lastSeen = json['lastSeen'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'firstName' : firstName,
    'lastName' : lastName,
    'email' : email,
    'countryCode' : countryCode,
    'phoneNumber' : phoneNumber,
    'password' : password,
    'profileImage' : profileImage,
    'isOnline' : isOnline,
    'lastSeen' : lastSeen,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}

class Pagination {
  final int? totalCount;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;

  Pagination({
    this.totalCount,
    this.totalPages,
    this.currentPage,
    this.pageSize,
  });

  Pagination.fromJson(Map<String, dynamic> json)
      : totalCount = json['totalCount'] as int?,
        totalPages = json['totalPages'] as int?,
        currentPage = json['currentPage'] as int?,
        pageSize = json['pageSize'] as int?;

  Map<String, dynamic> toJson() => {
    'totalCount' : totalCount,
    'totalPages' : totalPages,
    'currentPage' : currentPage,
    'pageSize' : pageSize
  };
}