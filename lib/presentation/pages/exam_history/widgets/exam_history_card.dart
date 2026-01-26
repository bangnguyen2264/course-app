import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/presentation/pages/exam_result/exam_result_utils.dart';
import 'package:flutter/material.dart';

class ExamHistoryCard extends StatelessWidget {
  final ExamResult result;
  const ExamHistoryCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.history, color: Colors.blue, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Điểm: ${result.score}', style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 4),
                  Text('Thời gian làm bài: ${formatDuration(result.timeTaken)} giây'),
                  const SizedBox(height: 4),
                  Text('Ngày tạo: ${_formatDate(result.createdAt)}'),
                  // Add more info if needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format as dd/MM/yyyy HH:mm or similar
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
