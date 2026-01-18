import 'package:course/app/resources/app_api.dart';
import 'package:course/app/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:async';

class DioConfig {
  static Dio? _dio;
  static Dio? _refreshDio; // Dio riêng cho refresh token
  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter; // Để các request khác đợi refresh hoàn thành

  static Dio getInstance() {
    if (_dio != null) return _dio!;

    _dio = Dio(
      BaseOptions(
        baseUrl: AppApi.baseUrl + AppApi.prefix,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        // Chỉ coi status 2xx là success, còn lại sẽ throw error để interceptor xử lý
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    // Add interceptors
    _dio!.interceptors.addAll([
      _authInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: false,
        filter: (options, args) {
          return true;
        },
      ),
      _errorInterceptor(),
    ]);

    return _dio!;
  }

  /// Dio riêng cho refresh token - không có auth interceptor để tránh vòng lặp
  static Dio _getRefreshDio() {
    if (_refreshDio != null) return _refreshDio!;

    _refreshDio = Dio(
      BaseOptions(
        baseUrl: AppApi.baseUrl + AppApi.prefix,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    return _refreshDio!;
  }

  // Auth Interceptor - Tự động thêm token vào header
  static Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Không thêm token cho endpoint refresh
        if (_isRefreshEndpoint(options.path)) {
          return handler.next(options);
        }

        final secureStorage = getIt<SecureStorage>();
        final token = await secureStorage.getAccessToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // Không xử lý refresh cho endpoint refresh token
        if (_isRefreshEndpoint(error.requestOptions.path)) {
          return handler.next(error);
        }

        // Handle token refresh logic on 401
        if (error.response?.statusCode == 401) {
          try {
            final success = await _handleTokenRefresh();
            if (success) {
              // Retry original request với token mới
              return handler.resolve(await _retry(error.requestOptions));
            }
          } catch (e) {
            // Token refresh failed
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Kiểm tra có phải endpoint refresh không
  static bool _isRefreshEndpoint(String path) {
    return path.contains(AppApi.authRefresh) || path.contains('/refresh');
  }

  /// Xử lý refresh token với lock để tránh nhiều request cùng refresh
  static Future<bool> _handleTokenRefresh() async {
    // Nếu đang refresh, đợi kết quả
    if (_isRefreshing) {
      return await _refreshCompleter?.future ?? false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final secureStorage = getIt<SecureStorage>();
      final refreshToken = await secureStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No refresh token available');
      }

      // Sử dụng Dio riêng để gọi refresh API
      final response = await _getRefreshDio().post(
        AppApi.authRefresh,
        options: Options(headers: {'X-Refresh-Token': refreshToken}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];

        if (newAccessToken != null) {
          await secureStorage.setAccessToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await secureStorage.setRefreshToken(newRefreshToken);
        }

        _refreshCompleter?.complete(true);
        return true;
      }

      throw Exception('Invalid refresh response');
    } catch (e) {
      _refreshCompleter?.complete(false);
      // Clear tokens khi refresh thất bại
      final secureStorage = getIt<SecureStorage>();
      await secureStorage.clearAll();
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  // Error Interceptor - Xử lý lỗi chung
  static Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String errorMessage = 'Đã xảy ra lỗi';
        Map<String, dynamic>? fieldErrors;

        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Kết nối timeout. Vui lòng thử lại';
        } else if (error.type == DioExceptionType.connectionError) {
          errorMessage = 'Không có kết nối internet';
        } else if (error.response != null) {
          final responseData = error.response!.data;

          switch (error.response!.statusCode) {
            case 400:
              // Xử lý validation error với cấu trúc mới
              if (responseData is Map<String, dynamic>) {
                // Lấy message từ error object
                if (responseData['error'] != null && responseData['error']['message'] != null) {
                  errorMessage = responseData['error']['message'];
                }

                // Lấy field errors
                if (responseData['fields'] != null) {
                  fieldErrors = Map<String, dynamic>.from(responseData['fields']);

                  // Tạo message từ field errors
                  final fieldMessages = fieldErrors.entries
                      .map((e) => '${_getFieldLabel(e.key)}: ${e.value}')
                      .join('\n');

                  if (fieldMessages.isNotEmpty) {
                    errorMessage = fieldMessages;
                  }
                }
              } else {
                errorMessage = 'Yêu cầu không hợp lệ';
              }
              break;

            case 401:
              if (responseData is Map<String, dynamic> &&
                  responseData['error'] != null &&
                  responseData['error']['message'] != null) {
                errorMessage = responseData['error']['message'];
              } else {
                errorMessage = 'Phiên đăng nhập hết hạn';
              }
              break;

            case 403:
              if (responseData is Map<String, dynamic> &&
                  responseData['error'] != null &&
                  responseData['error']['message'] != null) {
                errorMessage = responseData['error']['message'];
              } else {
                errorMessage = 'Không có quyền truy cập';
              }
              break;

            case 404:
              if (responseData is Map<String, dynamic> &&
                  responseData['error'] != null &&
                  responseData['error']['message'] != null) {
                errorMessage = responseData['error']['message'];
              } else {
                errorMessage = 'Không tìm thấy dữ liệu';
              }
              break;

            case 500:
              if (responseData is Map<String, dynamic> &&
                  responseData['error'] != null &&
                  responseData['error']['message'] != null) {
                errorMessage = responseData['error']['message'];
              } else {
                errorMessage = 'Lỗi server. Vui lòng thử lại sau';
              }
              break;

            default:
              if (responseData is Map<String, dynamic> &&
                  responseData['error'] != null &&
                  responseData['error']['message'] != null) {
                errorMessage = responseData['error']['message'];
              } else {
                errorMessage = 'Đã xảy ra lỗi';
              }
          }
        }

        return handler.next(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: errorMessage,
            message: errorMessage,
          ),
        );
      },
    );
  }

  // Convert field name sang tiếng Việt
  static String _getFieldLabel(String fieldName) {
    const fieldLabels = {
      'fullName': 'Họ tên',
      'email': 'Email',
      'password': 'Mật khẩu',
      'phoneNumber': 'Số điện thoại',
      'gender': 'Giới tính',
      'dob': 'Ngày sinh',
      'address': 'Địa chỉ',
    };
    return fieldLabels[fieldName] ?? fieldName;
  }

  // Retry request after token refresh
  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(method: requestOptions.method, headers: requestOptions.headers);

    return _dio!.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
