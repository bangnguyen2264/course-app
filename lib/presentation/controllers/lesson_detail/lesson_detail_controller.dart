import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/models/base_query_params.dart';
import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:course/domain/usecases/get_lesson_section_usecase.dart';
import 'package:course/presentation/controllers/lesson_detail/lesson_detail_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class LessonDetailController extends StateNotifier<LessonDetailState> {
  final GetLessonSectionUsecase _getLessonSectionUsecase;

  /// Số lượng item mỗi trang
  static const int _pageSize = 10;

  LessonDetailController(this._getLessonSectionUsecase) : super(const LessonDetailState());

  /// Khởi tạo với lesson
  void initialize(Lesson lesson) {
    state = state.copyWith(lesson: lesson);
  }

  /// Load danh sách sections
  Future<void> loadSections({int? lessonId}) async {
    if (state.isLoading) return;

    final targetLessonId = lessonId ?? state.lesson?.id;
    if (targetLessonId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null, currentPage: 0);

    try {
      final result = await _getLessonSectionUsecase(
        lessonId: targetLessonId,
        page: 0,
        entry: _pageSize,
        field: 'position',
        sort: SortOrder.asc,
      );

      state = state.copyWith(
        isLoading: false,
        sections: result.data,
        total: result.total,
        currentPage: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Refresh danh sách sections
  Future<void> refresh() async {
    state = LessonDetailState(lesson: state.lesson);
    await loadSections();
  }

  /// Clear lỗi
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Tải thêm sections (pagination)
  Future<void> loadMoreSections() async {
    if (!state.canLoadMore) return;

    final lessonId = state.lesson?.id;
    if (lessonId == null) return;

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _getLessonSectionUsecase(
        lessonId: lessonId,
        page: nextPage,
        entry: _pageSize,
        field: 'position',
        sort: SortOrder.asc,
      );

      final updatedSections = [...state.sections, ...result.data];
      state = state.copyWith(
        isLoadingMore: false,
        sections: updatedSections,
        total: result.total,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    }
  }
}

/// Provider cho LessonDetailController
final lessonDetailControllerProvider =
    StateNotifierProvider.autoDispose<LessonDetailController, LessonDetailState>((ref) {
      return LessonDetailController(getIt<GetLessonSectionUsecase>());
    });
