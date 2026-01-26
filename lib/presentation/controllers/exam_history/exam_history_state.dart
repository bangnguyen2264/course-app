import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:flutter/foundation.dart';

class ExamHistoryState {
  final List<ExamResult> examResults;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final int page;
  final int total;
  final int entry;

  ExamHistoryState({
    this.examResults = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.page = 1,
    this.total = 0,
    this.entry = 10,
  });

  ExamHistoryState copyWith({
    List<ExamResult>? examResults,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? page,
    int? total,
    int? entry,
  }) {
    return ExamHistoryState(
      examResults: examResults ?? this.examResults,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      total: total ?? this.total,
      entry: entry ?? this.entry,
    );
  }
}
