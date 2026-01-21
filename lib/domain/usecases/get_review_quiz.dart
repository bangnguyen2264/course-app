import 'package:course/domain/entities/api_response.dart';
import 'package:course/domain/quiz/quiz_review.dart';
import 'package:course/domain/repositories/query_param/quiz_query_param.dart';
import 'package:course/domain/repositories/quiz_repository.dart';

class GetReviewQuiz {
  final QuizRepository _quizRepository;

  GetReviewQuiz(this._quizRepository);

  Future<ApiResponse<QuizReview>> execute({
    int? examId,
    int page = 0,
    int entry = 10,
  }) async {
    final param = new QuizQueryParam(examId: examId, page: page, entry: entry);
    return _quizRepository.getQuizReview(param);
  }

}