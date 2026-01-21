import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/domain/entities/subject/subject.dart';

class ExamListState {
  final Subject? subject;
  final List<Exam> exams;
  final int total;
  final int currentPage;
  final String searchQuery;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const ExamListState({
    this.subject,
    this.exams = const [],
    this.total = 0,
    this.currentPage = 1,
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ExamListState copyWith({
    Subject? subject,
    List<Exam>? exams,
    int? total,
    int? currentPage,
    String? searchQuery,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ExamListState(
      subject: subject ?? this.subject,
      exams: exams ?? this.exams,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  /// Đã load xong khi không loading và có exams
  bool get isLoaded => !isLoading && exams.isNotEmpty;

  /// Có lỗi khi không loading và có errorMessage
  bool get hasError => !isLoading && errorMessage != null;

  /// Đã load hết dữ liệu khi số lượng exams >= total
  bool get hasReachedEnd => exams.length >= total && total > 0;

  /// Có thể load thêm không
  bool get canLoadMore => !isLoading && !isLoadingMore && !hasReachedEnd && exams.isNotEmpty;

  /// Đang tìm kiếm
  bool get isSearching => searchQuery.isNotEmpty;
}
