import 'package:course/app/di/dependency_injection.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/domain/usecases/get_subject_usecase.dart';
import 'package:course/presentation/controllers/exam/exam_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ExamController extends StateNotifier<ExamState> {
  final GetSubjectUsecase _getSubjectUsecase;

  /// Số lượng item mỗi trang
  static const int _pageSize = 20;

  ExamController(this._getSubjectUsecase) : super(const ExamState());

  /// Load danh sách môn học lần đầu
  Future<void> loadSubjects() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null, currentPage: 0);

    try {
      final result = await _getSubjectUsecase.execute(
        page: 0,
        entry: _pageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      state = state.copyWith(
        isLoading: false,
        subjects: result.subjects,
        total: result.total,
        currentPage: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Refresh danh sách môn học - reset state và load lại
  Future<void> refresh() async {
    final currentSelected = state.selectedSubject;
    state = ExamState(selectedSubject: currentSelected);
    await loadSubjects();
  }

  /// Clear lỗi
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Tải thêm môn học (pagination)
  Future<void> loadMoreSubjects() async {
    if (!state.canLoadMore) return;

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _getSubjectUsecase.execute(
        page: nextPage,
        entry: _pageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      final updatedSubjects = [...state.subjects, ...result.subjects];
      state = state.copyWith(
        isLoadingMore: false,
        subjects: updatedSubjects,
        total: result.total,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    }
  }

  /// Tìm kiếm môn học theo tên
  Future<void> search(String query) async {
    final trimmedQuery = query.trim();

    // Nếu query giống như hiện tại thì không làm gì
    if (trimmedQuery == state.searchQuery) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      searchQuery: trimmedQuery,
      currentPage: 0,
      subjects: [],
    );

    try {
      final result = await _getSubjectUsecase.execute(
        page: 0,
        entry: _pageSize,
        search: trimmedQuery.isEmpty ? null : trimmedQuery,
      );
      state = state.copyWith(
        isLoading: false,
        subjects: result.subjects,
        total: result.total,
        currentPage: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Chọn hoặc bỏ chọn một môn học
  void toggleSubjectSelection(Subject subject) {
    if (state.selectedSubject?.id == subject.id) {
      // Bỏ chọn nếu đã chọn
      state = state.copyWith(clearSelectedSubject: true);
    } else {
      // Chọn môn học mới
      state = state.copyWith(selectedSubject: subject);
    }
  }

  /// Clear subject selection
  void clearSelection() {
    state = state.copyWith(clearSelectedSubject: true);
  }
}

/// Provider cho ExamController
final examControllerProvider = StateNotifierProvider.autoDispose<ExamController, ExamState>((ref) {
  return ExamController(getIt<GetSubjectUsecase>());
});
