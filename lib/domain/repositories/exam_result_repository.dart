import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_detail.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_form_submit.dart';
import 'package:course/domain/repositories/query_param/exam_result_query_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'exam_result_repository.g.dart';
@RestApi()
abstract class ExamResultRepository {

  factory ExamResultRepository(Dio dio, {String baseUrl}) = _ExamResultRepository;

  @GET(AppApi.examResultList)
  Future<ApiResponse<ExamResult>> getExamResult(@Queries() ExamResultQueryParam queryParams);

  @POST(AppApi.examResultSubmit)
  Future<ExamResultDetail> submitExamResult(@Body() ExamResultFormSubmit body);

}