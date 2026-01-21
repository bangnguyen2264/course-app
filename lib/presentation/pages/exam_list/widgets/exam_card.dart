import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị một exam dạng card trong grid
class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback? onTap;

  const ExamCard({super.key, required this.exam, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.assignment_outlined, size: 28, color: AppColor.primary),
              ),
              const SizedBox(height: 12),
              // Exam title
              Text(
                exam.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColor.titleText,
                ),
              ),
              const Spacer(),
              // Duration
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColor.statisticLabel),
                  const SizedBox(width: 4),
                  Text(
                    '${exam.duration} phút',
                    style: TextStyle(fontSize: 13, color: AppColor.statisticLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
