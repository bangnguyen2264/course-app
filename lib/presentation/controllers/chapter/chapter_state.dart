import 'package:course/domain/entities/chapter/chapter.dart';
import 'package:course/domain/entities/subject/subject.dart';

class ChapterState {
  final Subject? subject;
  final List<Chapter> chapters;
  final int total;
  final int currentPage;
  final String searchQuery;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final Set<int> expandedChapterIds;

  const ChapterState({
    this.subject,
    this.chapters = const [],
    this.total = 0,
    this.currentPage = 1,
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.expandedChapterIds = const {},
  });

  ChapterState copyWith({
    Subject? subject,
    List<Chapter>? chapters,
    int? total,
    int? currentPage,
    String? searchQuery,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    Set<int>? expandedChapterIds,
  }) {
    return ChapterState(
      subject: subject ?? this.subject,
      chapters: chapters ?? this.chapters,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      expandedChapterIds: expandedChapterIds ?? this.expandedChapterIds,
    );
  }

  /// Đã load xong khi không loading và có chapters
  bool get isLoaded => !isLoading && chapters.isNotEmpty;

  /// Có lỗi khi không loading và có errorMessage
  bool get hasError => !isLoading && errorMessage != null;

  /// Đã load hết dữ liệu khi số lượng chapters >= total
  bool get hasReachedEnd => chapters.length >= total && total > 0;

  /// Có thể load thêm khi không loading, không lỗi và chưa hết data
  bool get canLoadMore => !isLoading && !isLoadingMore && !hasReachedEnd;

  /// Kiểm tra chapter có được expand không
  bool isChapterExpanded(int chapterId) => expandedChapterIds.contains(chapterId);

  /// Lấy tổng số chương
  int get chapterCount => total > 0 ? total : chapters.length;
}
