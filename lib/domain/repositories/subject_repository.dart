import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/domain/repositories/query_param/subject_query_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'subject_repository.g.dart';

@RestApi()
abstract class SubjectRepository {
  factory SubjectRepository(Dio dio, {String baseUrl}) = _SubjectRepository;

  @GET(AppApi.subjectList)
  Future<ApiResponse<Subject>> getSubjects(@Queries() SubjectQueryParams params);
}
