import 'dart:ffi';

import 'package:course/app/config/dio_config.dart';
import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/auth/login/login_request.dart';
import 'package:course/domain/entities/auth/login/login_response.dart';
import 'package:course/domain/entities/auth/register/register_request.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_repository.g.dart';

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST(AppApi.authLogin)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(AppApi.authRegister)
  Future<void> register(@Body() RegisterRequest request);

  @POST(AppApi.authRefresh)
  Future<LoginResponse> refreshToken(@Header('X-Refresh-Token') String refreshToken);
  // Thêm các API khác nếu cần, ví dụ refresh token...
}
