import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/domain/repositories/query_param/subject_query_param.dart';
import 'package:course/domain/repositories/subject_repository.dart';

/// Kết quả trả về từ GetSubjectUsecase
class SubjectResult {
  final List<Subject> subjects;
  final int total;

  const SubjectResult({required this.subjects, required this.total});
}

class GetSubjectUsecase {
  final SubjectRepository _subjectRepository;
  GetSubjectUsecase(this._subjectRepository);

  Future<SubjectResult> execute({int? page, int? entry, String? search}) async {
    final response = await _subjectRepository.getSubjects(
      SubjectQueryParams(page: page, entry: entry, name: search),
    );
    return SubjectResult(subjects: response.data, total: response.total);
  }
}
