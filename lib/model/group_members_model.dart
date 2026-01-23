class GroupMembersModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  GroupMembersModel({this.success, this.status, this.message, this.data});

  GroupMembersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? description;
  String? image;
  List<Members>? members;
  CreatedBy? createdBy;
  bool? isPrivate;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
        this.name,
        this.description,
        this.image,
        this.members,
        this.createdBy,
        this.isPrivate,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    isPrivate = json['isPrivate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['isPrivate'] = this.isPrivate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Members {
  String? sId;
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  String? role;
  String? joinedAt;

  Members(
      {this.sId,
        this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.profileImage,
        this.role,
        this.joinedAt});

  Members.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profileImage = json['profileImage'];
    role = json['role'];
    joinedAt = json['joinedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;
    data['role'] = this.role;
    data['joinedAt'] = this.joinedAt;
    return data;
  }
}

class CreatedBy {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;

  CreatedBy(
      {this.sId, this.firstName, this.lastName, this.email, this.profileImage});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
