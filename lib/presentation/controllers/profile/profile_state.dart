import 'package:course/domain/entities/user/user.dart';

/// State cho Profile ViewModel
class ProfileState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;
  final bool isLoggingOut;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.isLoggingOut = false,
  });

  ProfileState copyWith({bool? isLoading, User? user, String? errorMessage, bool? isLoggingOut}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  /// Đã load xong khi không loading và có user
  bool get isLoaded => !isLoading && user != null;

  /// Có lỗi khi không loading và có errorMessage
  bool get hasError => !isLoading && errorMessage != null;
}
