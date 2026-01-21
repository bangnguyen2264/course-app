import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/quiz/quiz.dart';
import 'package:course/domain/quiz/quiz_review.dart';
import 'package:course/domain/repositories/query_param/quiz_query_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'quiz_repository.g.dart';

@RestApi()
abstract class QuizRepository {
  factory QuizRepository(Dio dio, {String baseUrl}) = _QuizRepository;

  @GET(AppApi.quizList)
  Future<ApiResponse<Quiz>> getQuizList(@Queries() QuizQueryParam queryParams);

  @GET(AppApi.quizReview)
  Future<ApiResponse<QuizReview>> getQuizReview(@Queries() QuizQueryParam queryParams);
}
