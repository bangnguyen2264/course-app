import 'package:course/app/constants/app_routes.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/info_card.dart';
import 'widgets/exam_score_circle.dart';
import 'exam_result_utils.dart';

class ExamResultPage extends StatelessWidget {
  final ExamResultDetail? result;
  const ExamResultPage({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Scaffold(body: Center(child: Text('Không có dữ liệu kết quả bài thi.')));
    }
    final score = result!.score;
    final correct = result!.correct;
    final incorrect = result!.incorrect;
    final total = correct + incorrect;
    final timeTaken = formatDuration(result!.timeTaken);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Kết quả bài thi', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ExamScoreCircle(score: score),
              const SizedBox(height: 24),
              Text(
                getResultTitle(score),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: score == 10.0 ? Colors.orange : Colors.black,
                  shadows: score == 10.0
                      ? [Shadow(color: Colors.orange.withOpacity(0.5), blurRadius: 12)]
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                getResultSubtitle(score),
                style: TextStyle(
                  fontSize: 16,
                  color: score == 10.0 ? Colors.orange : const Color(0xFF219180),
                  fontWeight: score == 10.0 ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InfoCard(icon: Icons.access_time, label: 'THỜI GIAN', value: timeTaken),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InfoCard(
                      icon: Icons.check_circle,
                      label: 'CÂU ĐÚNG',
                      value: '$correct / $total',
                      valueColor: const Color(0xFF219180),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InfoCard(
                      icon: Icons.cancel,
                      label: 'CÂU SAI',
                      value: '$incorrect / $total',
                      valueColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF219180),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.description, color: Colors.white),
                  label: const Text('Xem lại đáp án', style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    if (result != null) {
                      context.pushReplacement(AppRoutes.examReview, extra: result);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Quay lại trang chủ', style: TextStyle(fontSize: 16)),
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }



}