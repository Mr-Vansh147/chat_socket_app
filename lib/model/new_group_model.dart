class NewGroupModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  NewGroupModel({this.success, this.status, this.message, this.data});

  NewGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] =status;
    data['message'] =message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? description;
  String? image;
  List<Members>? members;
  String? createdBy;
  bool? isPrivate;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.name,
        this.description,
        this.image,
        this.members,
        this.createdBy,
        this.isPrivate,
        this.sId,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = createdBy;
    data['isPrivate'] = isPrivate;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['role'] = role;
    data['_id'] = sId;
    data['joinedAt'] = joinedAt;
    return data;
  }
}
