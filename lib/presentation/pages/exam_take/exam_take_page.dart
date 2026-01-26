import 'dart:async';
import 'package:course/presentation/pages/exam_take/exam_review_before_submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import local của bạn (đảm bảo đường dẫn đúng)
import 'package:course/app/constants/app_routes.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/presentation/controllers/exam_take/exam_take_controller.dart';
import 'package:course/presentation/pages/exam_take/widgets/option_tile.dart';
import 'package:course/presentation/pages/exam_take/widgets/question_nav_grid.dart';
import 'package:course/presentation/pages/exam_take/widgets/submit_confirmation_dialog.dart';
import 'package:course/presentation/widgets/custom_dialog.dart';
import 'package:course/presentation/widgets/custom_app_bar.dart';

class ExamTakePage extends HookConsumerWidget {
  final Exam exam;
  const ExamTakePage({super.key, required this.exam});

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examTakeControllerProvider);
    final controller = ref.read(examTakeControllerProvider.notifier);

    // State cho đồng hồ
    final countdown = useState(state.totalSeconds ?? (exam.duration * 60));
    final elapsed = useState(0);

    useEffect(() {
      bool mounted = true;
      Timer? autoSubmitTimer;

      Future.microtask(() async {
        controller.initialize(examId: exam.id, durationSeconds: exam.duration * 60);
        await controller.loadQuestions();
        controller.startTimer();

        final totalSeconds = exam.duration * 60;
        countdown.value = totalSeconds;

        autoSubmitTimer = Timer(Duration(seconds: totalSeconds), () async {
          if (mounted) {
            final result = await controller.submit(timeTaken: elapsed.value);
            if (context.mounted) {
              context.pushReplacementNamed(AppRoutes.examResult, extra: result);
            }
          }
        });
      });

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

    final flaggedIndices = <int>{
      for (int i = 0; i < state.questions.length; i++)
        if (state.flagged.contains(state.questions[i].id)) i,
    };

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.scaffoldBackground,
          body: Column(
            children: [
              CustomAppBar(
                onBack: () => showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    status: DialogStatus.confirm,
                    title: 'Thoát làm bài',
                    content: 'Bạn có chắc chắn muốn thoát không? Mọi tiến độ sẽ không được lưu.',
                    confirmText: 'Thoát',
                    cancelText: 'Hủy',
                    onConfirm: () {
                      context.pop(); // Đóng dialog
                      context.pop(); // Thoát trang làm bài
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
                      QuestionNavGrid(
                        count: state.totalQuestions,
                        currentIndex: state.currentIndex,
                        answeredIndices: answeredIndices,
                        flaggedIndices: flaggedIndices,
                        onTap: (i) => controller.goTo(i),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Question ${state.currentIndex + 1}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColor.titleText,
                              ),
                            ),
                          ),
                          if (current != null)
                            IconButton(
                              icon: Icon(
                                state.flagged.contains(current.id)
                                    ? Icons.flag
                                    : Icons.outlined_flag,
                                color: state.flagged.contains(current.id)
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                              onPressed: () => controller.toggleFlag(current.id),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (current != null) ...[
                        Text(
                          current.question,
                          style: const TextStyle(fontSize: 16, color: AppColor.titleText),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          current.options.length,
                          (i) => Padding(
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
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Navigation Buttons
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
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ExamReviewBeforeSubmitPage(
                                            exam: exam,
                                            state: state,
                                            controller: controller,
                                            onSubmit: () => _showSubmitDialog(
                                              context,
                                              controller,
                                              state.selections.length,
                                              state,
                                              elapsed.value,
                                            ),
                                          ),
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
        ),
      ],
    );
  }

  void _showSubmitDialog(
    BuildContext context,
    dynamic controller,
    int answeredCount,
    dynamic state,
    int elapsed,
  ) {
    final unanswered = state.questions.length - answeredCount;
    showDialog(
      context: context,
      builder: (_) => SubmitConfirmationDialog(
        unansweredCount: unanswered,
        onConfirm: () async {
          controller.stopTimer();
          final result = await controller.submit(timeTaken: elapsed);
          if (context.mounted) {
            context.pushReplacement(AppRoutes.examResult, extra: result);
          }
        },
      ),
    );
  }
}
