import 'package:course/domain/entities/auth/register/register_request.dart';
import 'package:course/domain/entities/user/gender.dart';
import 'package:course/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<bool> execute({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
    required DateTime dob,
    required String address,
  }) async {
    try {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        gender: gender,
        dob: dob,
        address: address,
      );
      await _authRepository.register(request);
      return true; // Nếu không throw exception = success
    } catch (e) {
      return false; // Hoặc rethrow tùy logic
    }
  }
}
