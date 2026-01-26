import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/services/app_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:course/domain/usecases/get_exam_result_list_usecase.dart';
import 'package:course/presentation/controllers/exam_history/exam_history_state.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/domain/entities/api_response.dart';

final examHistoryControllerProvider =
    StateNotifierProvider<ExamHistoryController, ExamHistoryState>((ref) {
      final getExamResultListUseCase = ref.read(getExamResultListUseCaseProvider);
      final appPreferences = getIt<AppPreferences>();
      return ExamHistoryController(getExamResultListUseCase, appPreferences);
    });

class ExamHistoryController extends StateNotifier<ExamHistoryState> {
  final GetExamResultListUseCase _getExamResultListUseCase;
  final AppPreferences _appPreferences;
  int? _examId;

  ExamHistoryController(this._getExamResultListUseCase, this._appPreferences)
    : super(ExamHistoryState());

  void initialize({required int examId}) {
    _examId = examId;
    state = ExamHistoryState();
  }

  Future<void> loadExamResults() async {
    if (_examId == null) return;
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
      page: 0,
      examResults: [],
    );
    try {
      final ApiResponse<ExamResult> response = await _getExamResultListUseCase(
        examId: _examId,
        userId: await _appPreferences.getUserId(),
        page: 0,
        entry: state.entry,
      );
      state = state.copyWith(
        examResults: response.data,
        total: response.total,
        page: 0,
        isLoading: false,
        hasError: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.toString());
    }
  }

  Future<void> loadMoreExamResults() async {
    if (_examId == null) return;
    if (state.isLoadingMore) return;
    if (state.hasError) return;
    if (state.isLoading) return;
    if (state.examResults.length >= state.total || state.isLoadingMore) return;
    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true);
    try {
      final ApiResponse<ExamResult> response = await _getExamResultListUseCase(
        examId: _examId,
        userId: await _appPreferences.getUserId(),
        page: nextPage,
        entry: state.entry,
      );
      state = state.copyWith(
        examResults: [...state.examResults, ...response.data],
        total: response.total,
        page: nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, hasError: true, errorMessage: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadExamResults();
  }
}

final getExamResultListUseCaseProvider = Provider<GetExamResultListUseCase>((ref) {
  return getIt<GetExamResultListUseCase>();
});
