import 'package:course/domain/usecases/login_usecase.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:course/presentation/controllers/login/login_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

// Login Controller
class LoginController extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase) : super(LoginState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      await _loginUseCase.execute(email, password);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message ?? 'Đã xảy ra lỗi');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider cho LoginController
final loginControllerProvider = StateNotifierProvider.autoDispose<LoginController, LoginState>((
  ref,
) {
  return LoginController(getIt<LoginUseCase>());
});
