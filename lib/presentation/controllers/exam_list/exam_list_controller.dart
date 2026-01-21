import 'package:course/app/di/dependency_injection.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/domain/usecases/get_exam_list_usecase.dart';
import 'package:course/presentation/controllers/exam_list/exam_list_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ExamListController extends StateNotifier<ExamListState> {
  final GetExamListUsecase _getExamListUsecase;

  /// Số lượng item mỗi trang
  static const int _pageSize = 20;

  ExamListController(this._getExamListUsecase) : super(const ExamListState());

  /// Khởi tạo với subject
  void initialize(Subject subject) {
    state = state.copyWith(subject: subject);
  }

  /// Load danh sách exam lần đầu
  Future<void> loadExams({int? subjectId}) async {
    if (state.isLoading) return;

    final targetSubjectId = subjectId ?? state.subject?.id;
    if (targetSubjectId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null, currentPage: 0);

    try {
      final result = await _getExamListUsecase(
        subjectId: targetSubjectId,
        page: 0,
        entry: _pageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      state = state.copyWith(
        isLoading: false,
        exams: result.exams,
        total: result.total,
        currentPage: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Refresh danh sách exam - reset state và load lại
  Future<void> refresh() async {
    final currentSubject = state.subject;
    state = ExamListState(subject: currentSubject);
    await loadExams();
  }

  /// Clear lỗi
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Tải thêm exam (pagination)
  Future<void> loadMoreExams() async {
    if (!state.canLoadMore) return;

    final subjectId = state.subject?.id;
    if (subjectId == null) return;

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _getExamListUsecase(
        subjectId: subjectId,
        page: nextPage,
        entry: _pageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      final updatedExams = [...state.exams, ...result.exams];
      state = state.copyWith(
        isLoadingMore: false,
        exams: updatedExams,
        total: result.total,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    }
  }

  /// Tìm kiếm exam theo title
  Future<void> search(String query) async {
    final trimmedQuery = query.trim();

    // Nếu query giống như hiện tại thì không làm gì
    if (trimmedQuery == state.searchQuery) return;

    final subjectId = state.subject?.id;
    if (subjectId == null) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      searchQuery: trimmedQuery,
      currentPage: 0,
      exams: [],
    );

    try {
      final result = await _getExamListUsecase(
        subjectId: subjectId,
        page: 0,
        entry: _pageSize,
        search: trimmedQuery.isEmpty ? null : trimmedQuery,
      );
      state = state.copyWith(
        isLoading: false,
        exams: result.exams,
        total: result.total,
        currentPage: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

/// Provider cho ExamListController
final examListControllerProvider =
    StateNotifierProvider.autoDispose<ExamListController, ExamListState>((ref) {
      return ExamListController(getIt<GetExamListUsecase>());
    });
