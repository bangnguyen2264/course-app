import 'dart:async';

import 'package:course/app/constants/app_routes.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/presentation/controllers/exam_take/exam_take_controller.dart';
import 'package:course/presentation/controllers/exam_take/exam_take_state.dart';
import 'package:course/presentation/pages/exam_take/widgets/option_tile.dart';
import 'package:course/presentation/pages/exam_take/widgets/question_nav_grid.dart';
import 'package:course/presentation/pages/exam_take/widgets/submit_confirmation_dialog.dart';
import 'package:course/presentation/widgets/custom_dialog.dart';
import 'package:course/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamTakePage extends HookConsumerWidget {
  final Exam exam;
  const ExamTakePage({super.key, required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examTakeControllerProvider);
    final controller = ref.read(examTakeControllerProvider.notifier);

    // State cho đồng hồ đếm ngược
    final countdown = useState(state.totalSeconds ?? (exam.duration * 60));
    Timer? autoSubmitTimer;

    // Đồng hồ đếm xuôi chạy ngầm để gửi API, không hiển thị
    final elapsed = useState(0);

    useEffect(() {
      bool mounted = true;
      Future.microtask(() async {
        controller.initialize(examId: exam.id, durationSeconds: exam.duration * 60);
        await controller.loadQuestions();
        controller.startTimer();
        // Đặt timer tự động nộp bài khi hết giờ
        final totalSeconds = exam.duration * 60;
        countdown.value = totalSeconds;
        autoSubmitTimer = Timer(Duration(seconds: totalSeconds), () async {
          if (mounted) {
            final result = await controller.submit(timeTaken: elapsed.value);
            context.pushReplacementNamed(AppRoutes.examResult, extra: result);
          }
        });
      });
      // Đếm ngược cập nhật mỗi giây
      final ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          if (countdown.value > 0) countdown.value--;
          elapsed.value++;
        }
      });
      return () {
        mounted = false;
        controller.stopTimer();
        ticker.cancel();
        autoSubmitTimer?.cancel();
      };
    }, [exam.id]);

    if (state.isLoading && state.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.hasError && state.questions.isEmpty) {
      return Scaffold(body: Center(child: Text(state.errorMessage ?? 'Có lỗi xảy ra')));
    }

    final current = (state.questions.isNotEmpty) ? state.questions[state.currentIndex] : null;
    final selectedSet = state.selections[current?.id ?? -1] ?? {};
    final answeredIndices = <int>{
      for (int i = 0; i < state.questions.length; i++)
        if ((state.selections[state.questions[i].id] ?? {}).isNotEmpty) i,
    };

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          CustomAppBar(
            onBack: () => showDialog(
              context: context,
              builder: (context) => CustomDialog(
                status: DialogStatus.confirm,
                title: 'Thoát làm bài',
                content:
                    'Bạn có chắc chắn muốn thoát làm bài không? Mọi tiến độ sẽ không được lưu.',
                confirmText: 'Thoát',
                cancelText: 'Hủy',
                onConfirm: () {
                  context.pop();
                },
              ),
            ),
            title: exam.title,
            subtitle: _formatDuration(countdown.value),
            centerTitle: true,
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question navigation grid
                  QuestionNavGrid(
                    count: state.questions.length,
                    currentIndex: state.currentIndex,
                    answeredIndices: answeredIndices,
                    onTap: (i) => controller.goTo(i),
                  ),
                  const SizedBox(height: 16),
                  // Question title
                  Text(
                    'Question ${state.currentIndex + 1}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColor.titleText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (current != null)
                    Text(
                      current.question,
                      style: const TextStyle(fontSize: 16, color: AppColor.titleText),
                    ),
                  const SizedBox(height: 12),
                  // Options
                  if (current != null)
                    Column(
                      children: [
                        for (int i = 0; i < current.options.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: OptionTile(
                              label: current.options[i],
                              selected: selectedSet.contains(i),
                              multiple: current.multipleChoice,
                              onTap: () => controller.toggleOption(
                                current.id,
                                i,
                                multiple: current.multipleChoice,
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Bỏ flag toggle
                  const SizedBox(height: 24),
                  // Prev / Next buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state.canPrev ? controller.prev : null,
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: (state.currentIndex == state.questions.length - 1)
                            ? ElevatedButton(
                                onPressed: () {
                                  final unanswered =
                                      state.questions.length - answeredIndices.length;
                                  showDialog(
                                    context: context,
                                    builder: (_) => SubmitConfirmationDialog(
                                      unansweredCount: unanswered,
                                      onConfirm: () async {
                                        controller.stopTimer();
                                        autoSubmitTimer?.cancel();
                                        final result = await controller.submit(
                                          timeTaken: elapsed.value,
                                        );
                                        if (!context.mounted) return;
                                        context.pop();
                                        context.pushReplacement(
                                          AppRoutes.examResult,
                                          extra: result,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Text('Submit Exam'),
                              )
                            : ElevatedButton(
                                onPressed: state.canNext ? controller.next : null,
                                child: const Text('Next Question'),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
