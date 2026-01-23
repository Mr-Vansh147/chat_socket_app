class UpdateGroupProfileModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  UpdateGroupProfileModel({this.success, this.status, this.message, this.data});

  UpdateGroupProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? createdBy;
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
    createdBy = json['createdBy'];
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
    data['createdBy'] = this.createdBy;
    data['isPrivate'] = this.isPrivate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Members {
  String? userId;
  String? role;
  String? sId;
  String? joinedAt;

  Members({this.userId, this.role, this.sId, this.joinedAt});

  Members.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    role = json['role'];
    sId = json['_id'];
    joinedAt = json['joinedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['_id'] = this.sId;
    data['joinedAt'] = this.joinedAt;
    return data;
  }
}
