import 'package:flutter/material.dart';
import 'package:radial_progress/radial_progress.dart';

class ExamScoreCircle extends StatelessWidget {
  final double score;
  const ExamScoreCircle({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return RadialProgress(
      percent: score / 100,
      diameter: 180,
      progressLineWidth: 12,
      progressLineColors: const [Color(0xFF219180), Color(0xFF219180)],
      bgLineColor: Colors.grey.shade200,
      centerChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${score.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF219180),
            ),
          ),
          const SizedBox(height: 4),
          const Text('ĐIỂM CUỐI CÙNG'),
        ],
      ),
    );
  }
}
