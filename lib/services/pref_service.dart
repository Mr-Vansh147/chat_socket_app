import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static const String loginKey = "isLoggedIn";
  static const String userIdKey = "userID";
  static const String firstNameKey = "firstName";
  static const String profileImageKey = "profileImage";

  static Future<void> saveLogin({
    required bool isLoggedIn,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, isLoggedIn);
    await prefs.setString(userIdKey, userId);
  }

  static Future<void> saveUserMeta({
    required String firstName,
    required String profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(firstNameKey, firstName);
    await prefs.setString(profileImageKey, profileImage);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey) ?? false;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(firstNameKey);
  }


  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileImageKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
    await prefs.remove(userIdKey);
    await prefs.remove(firstNameKey);
    await prefs.remove(profileImageKey);
    print('LOGGED OUT');
  }
}
