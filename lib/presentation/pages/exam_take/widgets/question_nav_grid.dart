import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';

class QuestionNavGrid extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Set<int> answeredIndices;
  final void Function(int index)? onTap;

  const QuestionNavGrid({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.answeredIndices,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final isCurrent = index == currentIndex;
        final isAnswered = answeredIndices.contains(index);

        Color bg = AppColor.primary;
        if (!isAnswered) bg = AppColor.bgGrey;
        if (isCurrent) bg = AppColor.primary;

        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
