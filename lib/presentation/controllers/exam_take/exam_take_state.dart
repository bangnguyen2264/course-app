import 'dart:core';

import 'package:course/domain/quiz/quiz.dart';

class ExamTakeState {
  final int? examId;
  final List<Quiz> questions;
  final int currentIndex;
  final Map<int, Set<int>> selections; // questionId -> set of selected option indices
  final bool isLoading;
  final String? errorMessage;
  final int? totalSeconds; // exam duration in seconds
  final int remainingSeconds;
  final bool isSubmitting;

  const ExamTakeState({
    this.examId,
    this.questions = const [],
    this.currentIndex = 0,
    this.selections = const {},
    this.isLoading = false,
    this.errorMessage,
    this.totalSeconds,
    this.remainingSeconds = 0,
    this.isSubmitting = false,
  });

  ExamTakeState copyWith({
    int? examId,
    List<Quiz>? questions,
    int? currentIndex,
    Map<int, Set<int>>? selections,
    bool? isLoading,
    String? errorMessage,
    int? totalSeconds,
    int? remainingSeconds,
    bool? isSubmitting,
  }) {
    return ExamTakeState(
      examId: examId ?? this.examId,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selections: selections ?? this.selections,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  bool get hasError => errorMessage != null && !isLoading;
  bool get isLoaded => !isLoading && questions.isNotEmpty;
  bool get canPrev => currentIndex > 0;
  bool get canNext => currentIndex < (questions.length - 1);
}
