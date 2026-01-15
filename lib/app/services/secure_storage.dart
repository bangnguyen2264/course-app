import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service quản lý Flutter Secure Storage với Singleton pattern
/// Dùng để lưu trữ dữ liệu nhạy cảm như token, password
class SecureStorage {
  static SecureStorage? _instance;
  static FlutterSecureStorage? _storage;

  // Private constructor
  SecureStorage._();

  // Singleton instance
  static SecureStorage getInstance() {
    _instance ??= SecureStorage._();
    _storage ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    return _instance!;
  }

  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userPasswordKey = 'user_password';

  // Access Token
  Future<String?> getAccessToken() async {
    return await _storage?.read(key: _accessTokenKey);
  }

  Future<void> setAccessToken(String? token) async {
    if (token != null) {
      await _storage?.write(key: _accessTokenKey, value: token);
    } else {
      await _storage?.delete(key: _accessTokenKey);
    }
  }

  // Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage?.read(key: _refreshTokenKey);
  }

  Future<void> setRefreshToken(String? token) async {
    if (token != null) {
      await _storage?.write(key: _refreshTokenKey, value: token);
    } else {
      await _storage?.delete(key: _refreshTokenKey);
    }
  }

  // User Password (for biometric login)
  Future<String?> getUserPassword() async {
    return await _storage?.read(key: _userPasswordKey);
  }

  Future<void> setUserPassword(String? password) async {
    if (password != null) {
      await _storage?.write(key: _userPasswordKey, value: password);
    } else {
      await _storage?.delete(key: _userPasswordKey);
    }
  }

  // Clear all secure data
  Future<void> clearAll() async {
    await _storage?.deleteAll();
  }

  // Check if user has valid token
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> deleteAccessToken() async {
    await _storage?.delete(key: _accessTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _storage?.delete(key: _refreshTokenKey);
  }
}
