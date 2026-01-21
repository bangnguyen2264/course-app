import 'dart:async';

import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/services/app_preferences.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_form_submit.dart';
import 'package:course/domain/usecases/get_quiz_list_usecase.dart';
import 'package:course/domain/usecases/submit_exam_result_usecase.dart';
import 'package:course/presentation/controllers/exam_take/exam_take_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ExamTakeController extends StateNotifier<ExamTakeState> {
  final GetQuizListUsecase _getQuizList;
  final AppPreferences _appPreferences;
  final SubmitExamResultUsecase _submitUsecase;
  Timer? _timer;

  ExamTakeController(this._getQuizList, this._submitUsecase, this._appPreferences)
    : super(const ExamTakeState());

  void initialize({required int examId, int? durationSeconds}) {
    state = state.copyWith(
      examId: examId,
      totalSeconds: durationSeconds,
      remainingSeconds: durationSeconds ?? 0,
    );
  }

  Future<void> loadQuestions() async {
    final examId = state.examId;
    if (examId == null) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _getQuizList(examId: examId);
      state = state.copyWith(isLoading: false, questions: result.data, currentIndex: 0);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void startTimer() {
    final total = state.totalSeconds ?? 0;
    if (total <= 0) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final remaining = state.remainingSeconds - 1;
      if (remaining <= 0) {
        t.cancel();
        submitAuto();
      } else {
        state = state.copyWith(remainingSeconds: remaining);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void toggleOption(int questionId, int optionIndex, {bool multiple = false}) {
    final selections = Map<int, Set<int>>.from(state.selections);
    final current = selections[questionId] ?? <int>{};

    if (multiple) {
      if (current.contains(optionIndex)) {
        current.remove(optionIndex);
      } else {
        current.add(optionIndex);
      }
      selections[questionId] = current;
    } else {
      selections[questionId] = {optionIndex};
    }

    state = state.copyWith(selections: selections);
  }

  void goTo(int index) {
    if (index < 0 || index >= state.questions.length) return;
    state = state.copyWith(currentIndex: index);
  }

  void next() {
    if (!state.canNext) return;
    state = state.copyWith(currentIndex: state.currentIndex + 1);
  }

  void prev() {
    if (!state.canPrev) return;
    state = state.copyWith(currentIndex: state.currentIndex - 1);
  }

  Future<ExamResult?> submit({int? timeTaken}) async {
    final examId = state.examId;
    if (examId == null) {
      state = state.copyWith(isSubmitting: false, errorMessage: 'Exam ID không hợp lệ.');
      return null;
    }
    final userId = await _appPreferences.getUserId();
    if (userId == null) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Không tìm thấy thông tin người dùng.',
      );
      return null;
    }
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final form = ExamResultFormSubmit(
        examId: examId,
        userId: userId,
        timeTaken:
            timeTaken ??
            (state.totalSeconds != null ? state.totalSeconds! - state.remainingSeconds : 0),
        answers: state.selections.map((k, v) => MapEntry(k.toString(), v.toList())),
      );
      final result = await _submitUsecase(form);
      state = state.copyWith(isSubmitting: false, errorMessage: null);
      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Nộp bài thất bại: ${e.toString()}',
      );
      return null;
    }
  }

  Future<void> submitAuto({Function? onError, Function? onSuccess}) async {
    final result = await submit();
    if (result == null) {
      // Nếu có callback lỗi, gọi callback để UI xử lý chuyển hướng hoặc hiển thị lỗi
      if (onError != null) onError();
    } else {
      if (onSuccess != null) onSuccess();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final examTakeControllerProvider =
    StateNotifierProvider.autoDispose<ExamTakeController, ExamTakeState>((ref) {
      return ExamTakeController(
        getIt<GetQuizListUsecase>(),
        getIt<SubmitExamResultUsecase>(),
        getIt<AppPreferences>(),
      );
    });
