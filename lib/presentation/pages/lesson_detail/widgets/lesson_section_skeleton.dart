import 'package:flutter/material.dart';

class LessonSectionSkeleton extends StatelessWidget {
  const LessonSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _block(width: 200, height: 16),
          const SizedBox(height: 10),
          _block(width: double.infinity, height: 12),
          const SizedBox(height: 6),
          _block(width: double.infinity, height: 12),
          const SizedBox(height: 12),
          _block(width: double.infinity, height: 140),
        ],
      ),
    );
  }

  Widget _block({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
