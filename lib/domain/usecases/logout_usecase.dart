import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/services/app_preferences.dart';
import 'package:course/app/services/secure_storage.dart';

/// UseCase để đăng xuất người dùng
class LogoutUseCase {
  final SecureStorage _secureStorage;
  final AppPreferences _appPreferences;

  LogoutUseCase(this._secureStorage, this._appPreferences);

  Future<void> execute() async {
    // Xóa token
    await _secureStorage.deleteAccessToken();
    await _secureStorage.deleteRefreshToken();

    // Xóa thông tin user trong preferences
    await _appPreferences.setLoggedIn(false);
    await _appPreferences.setUserId(null);
    await _appPreferences.setUserName(null);
    await _appPreferences.setUserEmail(null);
  }
}

/// UseCase để logout từ DI
LogoutUseCase get logoutUseCase => getIt<LogoutUseCase>();
