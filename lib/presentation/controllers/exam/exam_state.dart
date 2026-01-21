import 'package:course/domain/entities/subject/subject.dart';

class ExamState {
  final List<Subject> subjects;
  final Subject? selectedSubject;
  final int total;
  final int currentPage;
  final String searchQuery;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const ExamState({
    this.subjects = const [],
    this.selectedSubject,
    this.total = 0,
    this.currentPage = 1,
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ExamState copyWith({
    List<Subject>? subjects,
    Subject? selectedSubject,
    int? total,
    int? currentPage,
    String? searchQuery,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearSelectedSubject = false,
  }) {
    return ExamState(
      subjects: subjects ?? this.subjects,
      selectedSubject: clearSelectedSubject ? null : (selectedSubject ?? this.selectedSubject),
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  /// Đã load xong khi không loading và có subjects
  bool get isLoaded => !isLoading && subjects.isNotEmpty;

  /// Có lỗi khi không loading và có errorMessage
  bool get hasError => !isLoading && errorMessage != null;

  /// Đã load hết dữ liệu khi số lượng subjects >= total
  bool get hasReachedEnd => subjects.length >= total && total > 0;

  /// Có thể load thêm không
  bool get canLoadMore => !isLoading && !isLoadingMore && !hasReachedEnd && subjects.isNotEmpty;

  /// Đang tìm kiếm
  bool get isSearching => searchQuery.isNotEmpty;
}
