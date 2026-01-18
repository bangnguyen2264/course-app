import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:course/domain/entities/lesson_section/lesson_section.dart';

/// State cho màn Lesson Detail
class LessonDetailState {
  final Lesson? lesson;
  final List<LessonSection> sections;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final int total;

  const LessonDetailState({
    this.lesson,
    this.sections = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 0,
    this.total = 0,
  });

  /// Kiểm tra có thể load thêm không
  bool get canLoadMore => !isLoading && !isLoadingMore && sections.length < total;

  /// Kiểm tra có lỗi không
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  /// Copy state với các giá trị mới
  LessonDetailState copyWith({
    Lesson? lesson,
    List<LessonSection>? sections,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    int? total,
  }) {
    return LessonDetailState(
      lesson: lesson ?? this.lesson,
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
    );
  }
}
