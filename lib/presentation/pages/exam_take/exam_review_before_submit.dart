import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/presentation/controllers/exam_take/exam_take_controller.dart';
import 'package:course/presentation/controllers/exam_take/exam_take_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamReviewBeforeSubmitPage extends ConsumerWidget {
  final Exam exam;
  final ExamTakeState state;
  final ExamTakeController controller;
  final void Function()? onSubmit;

  const ExamReviewBeforeSubmitPage({
    super.key,
    required this.exam,
    required this.state,
    required this.controller,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveState = ref.watch(examTakeControllerProvider);
    final questions = liveState.questions;
    final answered = liveState.selections;
    final flagged = liveState.flagged;
    final total = questions.length;
    final answeredCount = answered.values.where((s) => s.isNotEmpty).length;
    final flaggedCount = flagged.length;
    final leftCount = total - answeredCount;
    final percent = total > 0 ? (answeredCount / total * 100).round() : 0;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Submission Summary'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: BackButton(color: Colors.black),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'OVERALL PROGRESS',
                  style: TextStyle(
                    color: Colors.teal[300],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF219180),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$answeredCount of $total',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF219180)),
                    ),
                    const SizedBox(width: 4),
                    const Text('QUESTIONS ANSWERED', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: total > 0 ? answeredCount / total : 0,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF219180),
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _summaryBox(
                      Icons.check_circle,
                      'ANSWERED',
                      answeredCount,
                      const Color(0xFF219180),
                    ),
                    _summaryBox(Icons.radio_button_unchecked, 'LEFT', leftCount, Colors.grey),
                    _summaryBox(Icons.flag, 'FLAGGED', flaggedCount, Colors.orange),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Review Questions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'TAP A NUMBER TO EDIT',
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _questionGrid(context, questions, answered, flagged, controller),
                const SizedBox(height: 32),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF219180),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: onSubmit,
                child: const Text(
                  'Submit Exam',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        if (liveState.isSubmitting)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _summaryBox(IconData icon, String label, int value, Color color) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _questionGrid(
    BuildContext context,
    List questions,
    Map<int, Set<int>> answered,
    Set<int> flagged,
    ExamTakeController controller,
  ) {
    final int total = questions.length;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: total,
      itemBuilder: (context, i) {
        final q = questions[i];
        final isAnswered = (answered[q.id] ?? {}).isNotEmpty;
        final isFlagged = flagged.contains(q.id);
        return GestureDetector(
          onTap: () {
            controller.goTo(i);
            context.pop();
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isAnswered ? const Color(0xFF219180) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isAnswered ? const Color(0xFF219180) : Colors.grey[300]!,
                    width: isAnswered ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: isAnswered ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              if (isFlagged)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.flag, color: Colors.orange, size: 18),
                ),
            ],
          ),
        );
      },
    );
  }
}
