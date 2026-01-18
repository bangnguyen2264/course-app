import 'package:course/app/models/base_query_params.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/lesson_section/data_type.dart';
import 'package:course/domain/entities/lesson_section/lesson_section.dart';
import 'package:course/domain/repositories/lesson_section_repository.dart';
import 'package:course/domain/repositories/query_param/lesson_section_query_param.dart';

class GetLessonSectionUsecase {
  final LessonSectionRepository _lessonSectionRepository;

  GetLessonSectionUsecase(this._lessonSectionRepository);

  Future<ApiResponse<LessonSection>> call({
    int? lessonId,
    String? search,
    DataType? dataType,
    int? page,
    int? entry,
    String? field = 'id',
    SortOrder sort = SortOrder.asc,
  }) async {
    return await _lessonSectionRepository.getLessonSections(
      LessonSectionQueryParams(
        lessonId: lessonId,
        search: search,
        dataType: dataType,
        page: page,
        entry: entry,
        field: field!,
        sort: sort,
      ),
    );
  }
}
