import 'package:course/app/di/dependency_injection.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/domain/usecases/get_chapter_usecase.dart';
import 'package:course/presentation/controllers/chapter/chapter_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChapterController extends StateNotifier<ChapterState> {
  final GetChapterUsecase _getChapterUsecase;

  /// Số lượng item mỗi trang
  static const int _pageSize = 20;

  ChapterController(this._getChapterUsecase) : super(const ChapterState());

  /// Khởi tạo với subject
  void initialize(Subject subject) {
    state = state.copyWith(subject: subject);
  }

  /// Load danh sách chapters
  Future<void> loadChapters({int? subjectId}) async {
    if (state.isLoading) return;

    final targetSubjectId = subjectId ?? state.subject?.id;
    if (targetSubjectId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null, currentPage: 0);

    try {
      final result = await _getChapterUsecase(
        subjectId: targetSubjectId,
        page: 0,
        entry: _pageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      // Tự động expand chapter đầu tiên nếu có
      Set<int> initialExpanded = {};
      if (result.data.isNotEmpty) {
        initialExpanded = {result.data.first.id};
      }

      state = state.copyWith(
        isLoading: false,
        chapters: result.data,
        total: result.total,
        currentPage: 0,
        expandedChapterIds: initialExpanded,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Refresh danh sách chapters
  Future<void> refresh() async {
    state = ChapterState(subject: state.subject);
    await loadChapters();
  }

  /// Clear lỗi
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Tải thêm chapters (pagination)
  Future<void> loadMoreChapters() async {
    if (!state.canLoadMore) return;

    final subjectId = state.subject?.id;
    if (subjectId == null) return;

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _getChapterUsecase(
        subjectId: subjectId,
        page: nextPage,
        entry: _pageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      final updatedChapters = [...state.chapters, ...result.data];
      state = state.copyWith(
        isLoadingMore: false,
        chapters: updatedChapters,
        total: result.total,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    }
  }

  /// Toggle expand/collapse chapter
  void toggleChapterExpanded(int chapterId) {
    final currentExpanded = Set<int>.from(state.expandedChapterIds);
    if (currentExpanded.contains(chapterId)) {
      currentExpanded.remove(chapterId);
    } else {
      currentExpanded.add(chapterId);
    }
    state = state.copyWith(expandedChapterIds: currentExpanded);
  }

  /// Expand một chapter cụ thể
  void expandChapter(int chapterId) {
    if (!state.expandedChapterIds.contains(chapterId)) {
      final newExpanded = Set<int>.from(state.expandedChapterIds)..add(chapterId);
      state = state.copyWith(expandedChapterIds: newExpanded);
    }
  }

  /// Collapse một chapter cụ thể
  void collapseChapter(int chapterId) {
    if (state.expandedChapterIds.contains(chapterId)) {
      final newExpanded = Set<int>.from(state.expandedChapterIds)..remove(chapterId);
      state = state.copyWith(expandedChapterIds: newExpanded);
    }
  }

  /// Tìm kiếm chapters
  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery == state.searchQuery) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      searchQuery: trimmedQuery,
      currentPage: 0,
      chapters: [],
    );

    await loadChapters();
  }

  /// Xóa tìm kiếm
  Future<void> clearSearch() async {
    if (state.searchQuery.isEmpty) return;
    await search('');
  }

  /// Reset state
  void reset() {
    state = const ChapterState();
  }
}

/// Provider cho ChapterController
final chapterControllerProvider =
    StateNotifierProvider.autoDispose<ChapterController, ChapterState>((ref) {
      return ChapterController(getIt<GetChapterUsecase>());
    });

/// Provider để truyền subject vào chapter page
final selectedSubjectProvider = StateProvider<Subject?>((ref) => null);
