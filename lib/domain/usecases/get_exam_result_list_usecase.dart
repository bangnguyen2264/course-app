import 'package:course/app/models/base_query_params.dart';
import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/domain/repositories/exam_result_repository.dart';
import 'package:course/domain/repositories/query_param/exam_result_query_param.dart';

class GetExamResultListUseCase {
  // Implementation of the use case to get exam result list
  final ExamResultRepository _examResultRepository;

  GetExamResultListUseCase(this._examResultRepository);

  Future<ApiResponse<ExamResult>> call({
    int? examId,
    int? userId,
    int? page,
    int? entry,
    SortOrder sortOrder = SortOrder.desc,
    String field = 'createdAt',

  }) async {
    final response = await _examResultRepository.getExamResult(
      ExamResultQueryParam(examId: examId, userId: userId, page: page, entry: entry, sort: sortOrder, field: field),
    );
    return response;
  }
}