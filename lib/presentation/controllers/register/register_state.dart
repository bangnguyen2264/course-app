
// Register State
import 'package:course/domain/entities/user/gender.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final int currentPage;

  // Form data
  final String? fullName;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final Gender? gender;
  final DateTime? dob;
  final String? address;

  RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.currentPage = 0,
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.gender,
    this.dob,
    this.address,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    int? currentPage,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    Gender? gender,
    DateTime? dob,
    String? address,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      currentPage: currentPage ?? this.currentPage,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      address: address ?? this.address,
    );
  }

  bool canProceedFromPage(int page) {
    switch (page) {
      case 0: // Personal info: Họ tên, Ngày sinh, Giới tính
        return fullName != null && fullName!.isNotEmpty && dob != null && gender != null;
      case 1: // Contact info: Email, Số điện thoại
        return email != null && email!.isNotEmpty && phoneNumber != null && phoneNumber!.isNotEmpty;
      case 2: // Password info: Mật khẩu
        return password != null && password!.isNotEmpty;
      case 3: // Address info
        return address != null && address!.isNotEmpty;
      default:
        return false;
    }
  }
}