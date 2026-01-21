import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/domain/repositories/query_param/exam_query_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'exam_reposiroty.g.dart';
@RestApi()
abstract class ExamReposiroty {
  factory ExamReposiroty(Dio dio, {String baseUrl}) = _ExamReposiroty;

  @GET(AppApi.examList)
  Future<ApiResponse<Exam>> getExamList(@Queries() ExamQueryParam queryParams);
}