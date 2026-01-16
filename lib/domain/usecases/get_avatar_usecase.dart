import 'dart:typed_data';

import 'package:course/app/di/dependency_injection.dart';
import 'package:course/domain/repositories/file_repository.dart';

/// UseCase để lấy avatar image với authentication
class GetAvatarUseCase {
  final FileRepository _fileRepository;

  GetAvatarUseCase(this._fileRepository);

  /// Thực hiện fetch avatar từ server
  /// [avatarPath] - đường dẫn avatar trên server
  /// Returns [Uint8List] bytes của image hoặc null nếu có lỗi
  Future<Uint8List?> execute(String avatarPath) async {
    if (avatarPath.isEmpty) {
      return null;
    }
    return await _fileRepository.fetchImage(avatarPath);
  }
}

/// Getter để lấy GetAvatarUseCase từ DI
GetAvatarUseCase get getAvatarUseCase => getIt<GetAvatarUseCase>();
