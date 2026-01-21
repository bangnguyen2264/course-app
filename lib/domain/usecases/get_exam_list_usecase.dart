import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/domain/repositories/exam_reposiroty.dart';
import 'package:course/domain/repositories/query_param/exam_query_param.dart';

/// Kết quả trả về từ GetExamListUsecase
class ExamListResult {
  final List<Exam> exams;
  final int total;

  const ExamListResult({required this.exams, required this.total});
}

class GetExamListUsecase {
  final ExamReposiroty _examRepository;

  GetExamListUsecase(this._examRepository);

  Future<ExamListResult> call({
    required int subjectId,
    int? page,
    int? entry,
    String? search,
  }) async {
    final response = await _examRepository.getExamList(
      ExamQueryParam(subjectId: subjectId, search: search, page: page, entry: entry),
    );
    return ExamListResult(exams: response.data, total: response.total);
  }
}
