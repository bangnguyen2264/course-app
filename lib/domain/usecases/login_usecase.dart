import 'package:course/app/services/app_preferences.dart';
import 'package:course/domain/entities/auth/login/login_request.dart';
import 'package:course/domain/entities/auth/login/login_response.dart';
import 'package:course/domain/repositories/auth_repository.dart';
import 'package:course/app/services/secure_storage.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final SecureStorage _secureStorage;
  final AppPreferences _appPreferences;

  LoginUseCase(this._authRepository, this._secureStorage, this._appPreferences);

  Future<LoginResponse> execute(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    final response = await _authRepository.login(request);
    
    // Lưu token vào secure storage
    await _appPreferences.setUserId(response.id.toString());
    await _secureStorage.setAccessToken(response.token);
    await _secureStorage.setRefreshToken(response.refreshToken);
    
    return response;
  }
}