import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static const String loginKey = "isLoggedIn";
  static const String userIdKey = "userID";
  static const String firstNameKey = "firstName";
  static const String profileImageKey = "profileImage";

  static Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> saveLogin({
    required bool isLoggedIn,
    required String userId,
  }) async {
    final prefs = await _prefs();
    await prefs.setBool(loginKey, isLoggedIn);
    await prefs.setString(userIdKey, userId);

    print('PREF → LOGIN SAVED: $isLoggedIn, userId=$userId');
  }

  static Future<void> saveUserMeta({
    required String firstName,
    required String profileImage,
  }) async {
    final prefs = await _prefs();
    await prefs.setString(firstNameKey, firstName);
    await prefs.setString(profileImageKey, profileImage);

    print('PREF → USER META SAVED');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs();
    final value = prefs.getBool(loginKey) ?? false;

    print('PREF → isLoggedIn = $value');
    return value;
  }

  static Future<String?> getUserId() async {
    final prefs = await _prefs();
    final value = prefs.getString(userIdKey);

    print('PREF → userId = $value');
    return value;
  }

  static Future<String?> getFirstName() async {
    final prefs = await _prefs();
    return prefs.getString(firstNameKey);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await _prefs();
    return prefs.getString(profileImageKey);
  }

  static Future<void> logout() async {
    final prefs = await _prefs();

    await prefs.setBool(loginKey, false);

    await prefs.remove(userIdKey);
    await prefs.remove(firstNameKey);
    await prefs.remove(profileImageKey);

    print('PREF → LOGGED OUT (SAFE)');
  }
}