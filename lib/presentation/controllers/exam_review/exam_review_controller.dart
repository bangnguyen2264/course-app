import 'package:course/app/di/dependency_injection.dart';
import 'package:course/domain/quiz/quiz_review.dart';
import 'package:course/domain/usecases/get_review_quiz.dart';
import 'package:course/presentation/controllers/exam_review/exam_review_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamReviewNotifier extends StateNotifier<ExamReviewState> {
  final GetReviewQuiz _getReviewQuiz;
  final int examId;
  final int pageSize;

  ExamReviewNotifier(this._getReviewQuiz, this.examId, {this.pageSize = 10})
    : super(ExamReviewState(questions: const AsyncValue.loading())) {
    loadInitialPage();
  }

  Future<void> loadInitialPage() async {
    state = state.copyWith(questions: const AsyncValue.loading());

    await _fetchPage(0);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    await _fetchPage(state.currentPage + 1, isAppend: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(questions: const AsyncValue.loading(), currentPage: 0, hasMore: true);
    await loadInitialPage();
  }

  Future<void> _fetchPage(int page, {bool isAppend = false}) async {
    try {
      final response = await _getReviewQuiz.execute(examId: examId, page: page);

      if (response.data.isEmpty) {
        throw 'Không có dữ liệu để xem lại.';
      }

      final pagedData = response.data;

      final updatedList = isAppend
          ? <QuizReview>[...(state.questions.value ?? <QuizReview>[]), ...pagedData]
          : pagedData;

      state = state.copyWith(
        questions: AsyncValue.data(updatedList),
        currentPage: page,
        totalPages: response.total,
        hasMore: pagedData.length >= pageSize,
        totalQuestions: pagedData.length,
        isLoadingMore: false,
      );
    } catch (e, st) {
      state = state.copyWith(questions: AsyncValue.error(e, st), isLoadingMore: false);
    }
  }

  // Cho phép gọi lại khi cần (ví dụ retry)
  Future<void> retry() => refresh();
}

final examReviewController = StateNotifierProvider.autoDispose
    .family<ExamReviewNotifier, ExamReviewState, int>(
      (ref, examId) => ExamReviewNotifier(getIt<GetReviewQuiz>(), examId),
    );
