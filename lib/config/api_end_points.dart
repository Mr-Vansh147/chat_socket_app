class ApiEndPoints {
  static const String _baseUrl = 'http://192.168.1.52:2000';
  static const String socketUrl = "http://192.168.1.52:2000";

  static String register() => '$_baseUrl/api/v1/users/register';
  static String login() => '$_baseUrl/api/v1/users/login';
  static String uploadImage() => '$_baseUrl/api/v1/chat/upload-image';
  static String newGroup() => '$_baseUrl/api/v1/group/create';

  static String groupProfile({required String groupId}) {
    return '$_baseUrl/api/v1/group/$groupId';
  }

  static String getGroupList({
    required String id,
    String? search,
    String? page,
    String? pageSize,
  }) {
    return '$_baseUrl/api/v1/group/all/$id?page=$page&pageSize=$pageSize&search=$search';
  }

  static String getProfile({required String userId}) {
    return '$_baseUrl/api/v1/users/$userId';
  }

  static String updateProfile({required String userId}) {
    return '$_baseUrl/api/v1/users/$userId';
  }

  static String updateGroupProfile({
    required String userId,
    required String groupId,
  }) {
    return '$_baseUrl/api/v1/group/update';
  }

  static String getUserList({
    required String id,
    String? search,
    String? page,
    String? pageSize,
  }) {
    return '$_baseUrl/api/v1/users/allusers/$id?search=$search&page=$page&pageSize=$pageSize';
  }

  static String getMessages({
    required String senderId,
    required String receiverId,
  }) {
    return '$_baseUrl/api/v1/chat/history?senderId=$senderId&receiverId=$receiverId';
  }
}
