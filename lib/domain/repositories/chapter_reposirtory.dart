import 'package:course/app/resources/app_api.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/chapter/chapter.dart';
import 'package:course/domain/repositories/query_param/chapter_query_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'chapter_reposirtory.g.dart';

@RestApi()
abstract class ChapterRepository {
  factory ChapterRepository(Dio dio, {String baseUrl}) = _ChapterRepository;

  @GET(AppApi.chapterList)
  Future<ApiResponse<Chapter>> getChapters(@Queries() ChapterQueryParams params);
}
