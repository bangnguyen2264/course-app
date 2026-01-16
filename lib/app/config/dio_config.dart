import 'package:course/app/services/secure_storage.dart';
import 'package:course/domain/usecases/refresh_token_usecase.dart';
import 'package:dio/dio.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConfig {
  static Dio? _dio;
  static bool _isRefreshing = false;
  static final List<Future<Response>> _requestsToRetry = [];

  static Dio getInstance() {
    if (_dio != null) return _dio!;

    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8081/api', // TODO: Thay đổi base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) {
          return status != null && status < 500;
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
        compact: false, // true = compact, false = expanded
        // Filter: chỉ log error và response từ server
        filter: (options, args) {
          // Có thể filter theo endpoint nếu cần
          // return !options.uri.path.contains('/refresh-token');
          return true;
        },
      ),
      _errorInterceptor(),
    ]);

    return _dio!;
  }

  // Auth Interceptor - Tự động thêm token vào header
  static Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final secureStorage = getIt<SecureStorage>();
        final token = await secureStorage.getAccessToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token refresh logic on 401
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          try {
            // Refresh token
            final refreshTokenUsecase = getIt<RefreshTokenUsecase>();
            final newToken = await refreshTokenUsecase.refreshToken();

            // Retry original request với token mới
            _isRefreshing = false;
            return handler.resolve(await _retry(error.requestOptions));
          } catch (e) {
            _isRefreshing = false;
            // Token refresh failed, redirect to login
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    );
  }

  // Logging Interceptor - Log request và response
  static Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('┌───────────────────────────────────────────────────────────');
        print('│ Request: ${options.method} ${options.uri}');
        print('│ Headers: ${options.headers}');
        print('│ Data: ${options.data}');
        print('└───────────────────────────────────────────────────────────');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('┌───────────────────────────────────────────────────────────');
        print('│ Response: ${response.statusCode} ${response.requestOptions.uri}');
        print('│ Data: ${response.data}');
        print('└───────────────────────────────────────────────────────────');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('┌───────────────────────────────────────────────────────────');
        print('│ Error: ${error.response?.statusCode} ${error.requestOptions.uri}');
        print('│ Message: ${error.message}');
        print('│ Data: ${error.response?.data}');
        print('└───────────────────────────────────────────────────────────');
        return handler.next(error);
      },
    );
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
