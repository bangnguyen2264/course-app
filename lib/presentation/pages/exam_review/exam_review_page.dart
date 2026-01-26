import 'package:course/app/resources/app_style.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_detail.dart';
import 'package:course/domain/quiz/quiz_submission_result.dart';
import 'package:course/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamReviewPage extends ConsumerWidget {
  final ExamResultDetail examResult;

  const ExamReviewPage({super.key, required this.examResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizSubmissions = examResult.quizResultSubmissionList;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: examResult.examTitle),
      body: CustomScrollView(
        slivers: [
          // Header tóm tắt kết quả
          SliverToBoxAdapter(child: _buildResultSummary(context, theme)),
          // Danh sách câu hỏi
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final submission = quizSubmissions[index];
              return _buildQuestionCard(context, submission, theme);
            }, childCount: quizSubmissions.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Text(
              'Quay về trang chủ',
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultSummary(BuildContext context, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              examResult.examTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.score,
                  label: 'Điểm',
                  value: '${examResult.score}%',
                  color: theme.colorScheme.primary,
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.check_circle,
                  label: 'Đúng',
                  value: '${examResult.correct}',
                  color: AppColor.primary, // giữ màu đặc trưng đúng/sai
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.cancel,
                  label: 'Sai',
                  value: '${examResult.incorrect}',
                  color: AppColor.red,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  'Thời gian: ${examResult.timeTaken} giây',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    QuizSubmissionResult submission,
    ThemeData theme,
  ) {
    final correctIndices = _parseIndices(submission.correctAnswers);
    final userIndices = _parseIndices(submission.answer);

    final isCorrect =
        userIndices.length == correctIndices.length &&
        userIndices.every((i) => correctIndices.contains(i));

    final errorColor = theme.colorScheme.error;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header câu hỏi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isCorrect ? AppColor.primary : errorColor,
                  child: Text(
                    '${submission.id}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    submission.question,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Các lựa chọn
            ...List.generate(submission.options.length, (idx) {
              final text = submission.options[idx];
              final isUserSelected = userIndices.contains(idx);
              final isCorrectOption = correctIndices.contains(idx);

              Color? bgColor;
              Color? borderColor;
              Color? textColor = theme.colorScheme.onSurface;
              IconData? trailingIcon;

              if (isUserSelected) {
                if (isCorrectOption) {
                  bgColor = AppColor.primary.withOpacity(0.1);
                  borderColor = AppColor.primary;
                  textColor = AppColor.primary;
                  trailingIcon = Icons.check_circle;
                } else {
                  bgColor = errorColor.withOpacity(0.1);
                  borderColor = errorColor;
                  textColor = errorColor;
                  trailingIcon = Icons.cancel;
                }
              } else if (isCorrectOption) {
                bgColor = AppColor.primary.withOpacity(0.08);
                borderColor = AppColor.primary.withOpacity(0.6);
                textColor = AppColor.primary;
                trailingIcon = Icons.check_circle_outline;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor ?? theme.cardColor,
                  border: Border.all(
                    color: borderColor ?? theme.dividerColor,
                    width: isUserSelected || isCorrectOption ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: isCorrectOption || isUserSelected
                              ? FontWeightsManager.semiBold
                              : FontWeightsManager.medium,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) Icon(trailingIcon, color: textColor, size: 24),
                  ],
                ),
              );
            }),

            // Hiển thị đáp án đúng nếu sai
            if (!isCorrect && correctIndices.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppColor.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Đáp án đúng: ${correctIndices.map((i) => submission.options[i]).join(', ')}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<int> _parseIndices(String? str) {
    if (str == null || str.isEmpty) return [];
    try {
      final cleaned = str.replaceAll('[', '').replaceAll(']', '').trim();
      if (cleaned.isEmpty) return [];
      return cleaned
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? -1)
          .where((i) => i >= 0)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
