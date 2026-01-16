import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/services/app_preferences.dart';
import 'package:course/domain/entities/user/user.dart';
import 'package:course/domain/repositories/user_repository.dart';

/// UseCase để lấy thông tin user hiện tại
class GetUserUseCase {
  final UserRepository _userRepository;
  final AppPreferences _appPreferences;

  GetUserUseCase(this._userRepository, this._appPreferences);

  Future<User> execute() async {
    final userId = await _appPreferences.getUserId();
    if (userId == null) {
      throw Exception('User ID không tồn tại');
    }
    return await _userRepository.getUser(int.parse(userId));
  }
}

/// UseCase để lấy user từ DI
GetUserUseCase get getUserUseCase => getIt<GetUserUseCase>();
