import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/services/app_preferences.dart';
import 'package:course/domain/usecases/logout_usecase.dart';
import 'package:course/presentation/controllers/profile/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

/// ViewModel cho Profile - quản lý logic và state
class ProfileController extends StateNotifier<ProfileState> {
  final AppPreferences _appPreferences;
  final LogoutUseCase _logoutUseCase;

  ProfileController(this._appPreferences, this._logoutUseCase) : super(const ProfileState());

  /// Load thông tin user
  Future<void> loadUser() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final username = await _appPreferences.getUserName() ?? '';
      final avatarUrl = await _appPreferences.getAvatarUrl() ?? '';
      state = state.copyWith(isLoading: false, username: username, avatarUrl: avatarUrl);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.response?.data?['message'] ?? e.message ?? 'Lỗi kết nối',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Đăng xuất
  Future<bool> logout() async {
    state = state.copyWith(isLoggingOut: true);

    try {
      await _logoutUseCase.execute();
      state = state.copyWith(isLoggingOut: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoggingOut: false, errorMessage: 'Lỗi đăng xuất: ${e.toString()}');
      return false;
    }
  }

  /// Refresh user data
  Future<void> refresh() async {
    await loadUser();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider cho ProfileController
final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(getIt<AppPreferences>(), getIt<LogoutUseCase>());
});
