import 'package:course/domain/usecases/register_usecase.dart';
import 'package:course/domain/entities/user/gender.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:course/presentation/controllers/register/register_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';


// Register Controller
class RegisterController extends StateNotifier<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterController(this._registerUseCase) : super(RegisterState());

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void nextPage() {
    if (state.currentPage < 3) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setPhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void setGender(Gender value) {
    state = state.copyWith(gender: value);
  }

  void setDob(DateTime value) {
    state = state.copyWith(dob: value);
  }

  void setAddress(String value) {
    state = state.copyWith(address: value);
  }

  Future<bool> register() async {
    if (state.fullName == null ||
        state.email == null ||
        state.password == null ||
        state.phoneNumber == null ||
        state.gender == null ||
        state.dob == null ||
        state.address == null) {
      state = state.copyWith(errorMessage: 'Vui lòng điền đầy đủ thông tin');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      await _registerUseCase.execute(
        fullName: state.fullName!,
        email: state.email!,
        password: state.password!,
        phoneNumber: state.phoneNumber!,
        gender: state.gender!,
        dob: state.dob!,
        address: state.address!,
      );
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

// Provider cho RegisterController
final registerControllerProvider =
    StateNotifierProvider.autoDispose<RegisterController, RegisterState>((ref) {
      return RegisterController(getIt<RegisterUseCase>());
    });
