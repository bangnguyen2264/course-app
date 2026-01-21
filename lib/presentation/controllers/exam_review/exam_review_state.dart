import 'package:course/domain/quiz/quiz_review.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamReviewState {
  final AsyncValue<List<QuizReview>> questions;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final bool hasMore;
  final int totalQuestions;

  ExamReviewState({
    required this.questions,
    this.currentPage = 0,
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.totalQuestions = 0,
  });

  ExamReviewState copyWith({
    AsyncValue<List<QuizReview>>? questions,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    bool? hasMore,
    int? totalQuestions,
  }) {
    return ExamReviewState(
      questions: questions ?? this.questions,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }
}