import 'dart:typed_data';

import 'package:course/app/resources/app_api.dart';
import 'package:course/app/services/secure_storage.dart';
import 'package:dio/dio.dart';

/// Repository để fetch file với authentication token
class FileRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;

  FileRepository(this._dio, this._secureStorage);

  /// Fetch file từ server với token authorization
  /// [path] - đường dẫn file trên server (không bao gồm baseUrl)
  /// Returns [Uint8List] bytes của file hoặc null nếu có lỗi
  Future<Uint8List?> fetchFile(String path) async {
    try {
      final token = await _secureStorage.getAccessToken();
      final url = AppApi.baseUrl + path;

      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          headers: {if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch image từ server với token authorization
  /// [imagePath] - đường dẫn image trên server
  Future<Uint8List?> fetchImage(String imagePath) async {
    return await fetchFile(imagePath);
  }
}
