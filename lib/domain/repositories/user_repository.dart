import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/user/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'user_repository.g.dart';
@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET(AppApi.userById)
  Future<User> getUser(@Path('id') int id);
}