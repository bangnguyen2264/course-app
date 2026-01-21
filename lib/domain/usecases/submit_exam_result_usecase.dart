import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_form_submit.dart';
import 'package:course/domain/repositories/exam_result_repository.dart';

class SubmitExamResultUsecase {
  final ExamResultRepository _repo;
  SubmitExamResultUsecase(this._repo);

  Future<ExamResult> call(ExamResultFormSubmit form) async {
    return await _repo.submitExamResult(form);
  }
}
