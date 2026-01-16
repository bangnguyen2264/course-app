import 'package:course/app/services/secure_storage.dart';
import 'package:course/domain/repositories/auth_repository.dart';

class RefreshTokenUsecase {
  final AuthRepository _authRepository;
  final SecureStorage _secureStorage;

  RefreshTokenUsecase(this._authRepository, this._secureStorage);
  // Refresh token
  Future<String> refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');
    
    final response = await _authRepository.refreshToken(refreshToken);
    
    // Lưu token mới
    await _secureStorage.setAccessToken(response.token);
    await _secureStorage.setRefreshToken(response.refreshToken);
    
    return response.token;
  }

  // Logout
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    return await _secureStorage.hasValidToken();
  }
}