import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';

class QuestionNavGrid extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Set<int> answeredIndices;
  final Set<int> flaggedIndices; // Thêm bộ lưu các câu đã đánh dấu
  final void Function(int index)? onTap;

  const QuestionNavGrid({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.answeredIndices,
    this.flaggedIndices = const {}, // Mặc định là trống
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Chiều cao của thanh điều hướng
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isCurrent = index == currentIndex;
          final isAnswered = answeredIndices.contains(index);
          final isFlagged = flaggedIndices.contains(index);

          // Xác định Style dựa trên trạng thái
          Color bgColor = const Color(0xFFF5F5F5); // Mặc định xám nhạt
          Color textColor = Colors.grey;
          BoxBorder? border;

          if (isCurrent) {
            bgColor = Colors.white;
            textColor = const Color(0xFF2D8B81); // Xanh đậm
            border = Border.all(color: const Color(0xFF2D8B81), width: 2);
          } else if (isAnswered) {
            bgColor = const Color(0xFF2D8B81);
            textColor = Colors.white;
          } else if (isFlagged) {
            bgColor = const Color(0xFFFFF1E0); // Cam nhạt
            textColor = const Color(0xFFE67E22); // Chữ cam
            border = Border.all(color: const Color(0xFFFFB347), width: 1.5);
          }

          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: border,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                // Chấm cam nhỏ nếu được Flagged
                if (isFlagged)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
