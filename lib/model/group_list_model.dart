class GroupListModel {
  bool? success;
  int? status;
  String? message;
  List<GroupData>? data;
  Pagination? pagination;

  GroupListModel(
      {this.success, this.status, this.message, this.data, this.pagination});

  GroupListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GroupData>[];
      json['data'].forEach((v) {
        data!.add(new GroupData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class GroupData {
  String? sId;
  String? name;
  String? description;
  String? image;
  List<Members>? members;
  CreatedBy? createdBy;
  bool? isPrivate;
  String? createdAt;
  String? updatedAt;

  GroupData(
      {this.sId,
        this.name,
        this.description,
        this.image,
        this.members,
        this.createdBy,
        this.isPrivate,
        this.createdAt,
        this.updatedAt});

  GroupData.fromJson(Map<String, dynamic> json) {
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

class Pagination {
  int? totalCount;
  int? totalPages;
  int? currentPage;
  int? pageSize;

  Pagination(
      {this.totalCount, this.totalPages, this.currentPage, this.pageSize});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
