
/// State cho Profile ViewModel
class ProfileState {
  final bool isLoading;
  final String? username;
  final String? avatarUrl;
  final String? errorMessage;
  final bool isLoggingOut;

  const ProfileState({
    this.isLoading = false,
    this.username,
    this.avatarUrl,
    this.errorMessage,
    this.isLoggingOut = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? username,
    String? avatarUrl,
    String? errorMessage,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  /// Đã load xong khi không loading và có user
  bool get isLoaded => !isLoading && username != null;

  /// Có lỗi khi không loading và có errorMessage
  bool get hasError => !isLoading && errorMessage != null;
}
