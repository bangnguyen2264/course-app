import 'package:shared_preferences/shared_preferences.dart';

/// Service quản lý SharedPreferences với Singleton pattern
class AppPreferences {
  static AppPreferences? _instance;
  static SharedPreferences? _preferences;

  // Private constructor
  AppPreferences._();

  // Singleton instance
  static Future<AppPreferences> getInstance() async {
    _instance ??= AppPreferences._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys
  static const String _hasSeenIntroKey = 'has_seen_intro';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userTokenKey = 'user_token';
  static const String _themeMode = 'theme_mode';
  static const String _languageCode = 'language_code';

  // Has Seen Intro
  Future<bool> hasSeenIntro() async {
    return _preferences?.getBool(_hasSeenIntroKey) ?? false;
  }

  Future<void> setHasSeenIntro(bool value) async {
    await _preferences?.setBool(_hasSeenIntroKey, value);
  }

  // Login Status
  Future<bool> isLoggedIn() async {
    return _preferences?.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await _preferences?.setBool(_isLoggedInKey, value);
  }

  // User ID
  Future<String?> getUserId() async {
    return _preferences?.getString(_userIdKey);
  }

  Future<void> setUserId(String? userId) async {
    if (userId != null) {
      await _preferences?.setString(_userIdKey, userId);
    } else {
      await _preferences?.remove(_userIdKey);
    }
  }

  // User Name
  Future<String?> getUserName() async {
    return _preferences?.getString(_userNameKey);
  }

  Future<void> setUserName(String? userName) async {
    if (userName != null) {
      await _preferences?.setString(_userNameKey, userName);
    } else {
      await _preferences?.remove(_userNameKey);
    }
  }

  // User Email
  Future<String?> getUserEmail() async {
    return _preferences?.getString(_userEmailKey);
  }

  Future<void> setUserEmail(String? email) async {
    if (email != null) {
      await _preferences?.setString(_userEmailKey, email);
    } else {
      await _preferences?.remove(_userEmailKey);
    }
  }

  // User Token
  Future<String?> getUserToken() async {
    return _preferences?.getString(_userTokenKey);
  }

  Future<void> setUserToken(String? token) async {
    if (token != null) {
      await _preferences?.setString(_userTokenKey, token);
    } else {
      await _preferences?.remove(_userTokenKey);
    }
  }

  // Theme Mode
  Future<String?> getThemeMode() async {
    return _preferences?.getString(_themeMode);
  }

  Future<void> setThemeMode(String mode) async {
    await _preferences?.setString(_themeMode, mode);
  }

  // Language Code
  Future<String?> getLanguageCode() async {
    return _preferences?.getString(_languageCode);
  }

  Future<void> setLanguageCode(String code) async {
    await _preferences?.setString(_languageCode, code);
  }

  // Clear all user data (for logout)
  Future<void> clearUserData() async {
    await _preferences?.remove(_userIdKey);
    await _preferences?.remove(_userNameKey);
    await _preferences?.remove(_userEmailKey);
    await _preferences?.remove(_userTokenKey);
    await _preferences?.setBool(_isLoggedInKey, false);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _preferences?.clear();
  }
}
