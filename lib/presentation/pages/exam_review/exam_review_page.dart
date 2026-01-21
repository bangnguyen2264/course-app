import 'package:course/presentation/controllers/exam_review/exam_review_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:course/domain/quiz/quiz_review.dart';

class ExamReviewPage extends ConsumerStatefulWidget {
  final int examId;
  const ExamReviewPage({super.key, required this.examId});

  @override
  ConsumerState<ExamReviewPage> createState() => _ExamReviewPageState();
}

class _ExamReviewPageState extends ConsumerState<ExamReviewPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Tự động load more khi scroll gần cuối (infinite scroll)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(examReviewController(widget.examId).notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examReviewController(widget.examId));

    return Scaffold(
      appBar: AppBar(title: const Text('Xem lại đáp án'), centerTitle: true),
      body: state.questions.when(
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final hasMore = state.hasMore;
          final isLoadingMore = state.isLoadingMore;

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(examReviewController(widget.examId).notifier).refresh();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: questions.length + (hasMore || isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == questions.length) {
                  // Footer loading / load more
                  if (isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (!hasMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('Đã xem hết câu hỏi')),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final q = questions[index];
                return _buildQuestionCard(q);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Lỗi: $err'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => ref.read(examReviewController(widget.examId).notifier).retry(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Về trang chủ'),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuizReview q) {
    // Parse correctAnswers từ string "[3]" hoặc "[0,2,3]" thành List<int>
    final correctIndices = _parseCorrectAnswers(q.correctAnswers);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Câu hỏi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Câu ${q.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    q.question,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danh sách các lựa chọn
            ...List.generate(q.options.length, (index) {
              final optionText = q.options[index];
              final isCorrect = correctIndices.contains(index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon chỉ báo đúng/sai
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.circle_outlined,
                      color: isCorrect ? Colors.green : Colors.grey[500],
                      size: 24,
                    ),
                    const SizedBox(width: 12),

                    // Nội dung lựa chọn
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: isCorrect ? Colors.green[800] : Colors.black87,
                            fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),

                    // (Tùy chọn) Thêm nhãn "Đáp án đúng" nếu muốn rõ ràng hơn
                    if (isCorrect)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Đúng',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),

            // (Tùy chọn) Thêm dòng tóm tắt số đáp án đúng
            if (correctIndices.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      const TextSpan(text: 'Đáp án đúng: '),
                      ...List.generate(correctIndices.length, (idx) {
                        final optionText = q.options[correctIndices[idx]];
                        return [
                          TextSpan(
                            text: optionText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388E3C), // green[800]
                            ),
                          ),
                          if (idx < correctIndices.length - 1) const TextSpan(text: ', '),
                        ];
                      }).expand((x) => x),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Hàm helper để parse correctAnswers từ string dạng "[0,2]" hoặc "[3]"
  List<int> _parseCorrectAnswers(String correctAnswersStr) {
    try {
      // Loại bỏ dấu ngoặc vuông và tách theo dấu phẩy
      final cleaned = correctAnswersStr.replaceAll('[', '').replaceAll(']', '').trim();

      if (cleaned.isEmpty) return [];

      return cleaned
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? -1)
          .where((index) => index >= 0)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
