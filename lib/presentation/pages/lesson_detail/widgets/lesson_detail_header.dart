import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:flutter/material.dart';

class LessonDetailHeader extends StatelessWidget {
  final Lesson lesson;
  final int sectionCount;
  final int estimatedMinutes;
  final String chapterLabel;

  const LessonDetailHeader({
    super.key,
    required this.lesson,
    required this.sectionCount,
    required this.estimatedMinutes,
    required this.chapterLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapterLabel.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColor.titleText,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetaItem(icon: Icons.access_time_rounded, label: '$estimatedMinutes min read'),
              const SizedBox(width: 16),
              _MetaItem(icon: Icons.menu_book_outlined, label: '$sectionCount Sections'),
            ],
          ),
          if (lesson.description != null && lesson.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              lesson.description!,
              style: const TextStyle(fontSize: 14, color: AppColor.statisticLabel, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.titleText),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColor.titleText,
          ),
        ),
      ],
    );
  }
}
