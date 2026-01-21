import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/quiz/quiz.dart';
import 'package:course/domain/repositories/quiz_repository.dart';
import 'package:course/domain/repositories/query_param/quiz_query_param.dart';

class GetQuizListUsecase {
  final QuizRepository _quizRepository;
  GetQuizListUsecase(this._quizRepository);

  Future<ApiResponse<Quiz>> call({required int examId, int? page, int? entry}) async {
    final resp = await _quizRepository.getQuizList(
      QuizQueryParam(examId: examId, page: page, entry: entry),
    );
    return resp;
  }
}
