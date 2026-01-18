


import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/lesson_section/lesson_section.dart';
import 'package:course/domain/repositories/query_param/lesson_section_query_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'lesson_section_repository.g.dart';
@RestApi()
abstract class LessonSectionRepository {
  factory LessonSectionRepository(Dio dio, {String baseUrl}) = _LessonSectionRepository;

  @GET(AppApi.lessonSectionList)
  Future<ApiResponse<LessonSection>> getLessonSections(@Queries() LessonSectionQueryParams queryParams);

}