import 'package:course/app/models/base_query_params.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/chapter/chapter.dart';
import 'package:course/domain/repositories/chapter_reposirtory.dart';
import 'package:course/domain/repositories/query_param/chapter_query_param.dart';

class GetChapterUsecase {
  final ChapterRepository _chapterRepository;

  GetChapterUsecase(this._chapterRepository);

  Future<ApiResponse<Chapter>> call({
    int? subjectId,
    String? search,
    int? page,
    int? entry,
    String? field = 'id',
    SortOrder sort = SortOrder.asc,
  }) async {
    return await _chapterRepository.getChapters(
      ChapterQueryParams(
        subjectId: subjectId,
        search: search,
        page: page,
        entry: entry,
        field: field!,
        sort: sort,
      ),
    );
  }
}
