class PassGroupModel {
  final String groupId;
  final String groupName;
  final String? groupImage;
  final String? groupDescription;

  PassGroupModel({
    required this.groupId,
    required this.groupName,
    this.groupImage,
    this.groupDescription,
  });
}
