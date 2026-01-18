import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/chapter/chapter.dart';
import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị một bài học trong danh sách
class LessonItemWidget extends StatelessWidget {
  final int index;
  final Lesson lesson;
  final VoidCallback? onTap;

  const LessonItemWidget({super.key, required this.index, required this.lesson, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Status icon - default to not started
            // _buildStatusIcon(),
            const SizedBox(width: 12),
            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index. ${lesson.title}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.titleText,
                    ),
                  ),
                  if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      lesson.description!,
                      style: TextStyle(fontSize: 12, color: AppColor.statisticLabel),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //   Widget _buildStatusIcon() {
  //     // Default: not started circle
  //     return Container(
  //       width: 24,
  //       height: 24,
  //       decoration: BoxDecoration(
  //         border: Border.all(color: AppColor.statisticLabel, width: 2),
  //         shape: BoxShape.circle,
  //       ),
  //     );
  //   }
}

/// Widget hiển thị một chương (có thể expand/collapse)
class ChapterCardWidget extends StatelessWidget {
  final int index;
  final Chapter chapter;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(Lesson lesson)? onLessonTap;

  const ChapterCardWidget({
    super.key,
    required this.index,
    required this.chapter,
    required this.isExpanded,
    required this.onToggle,
    this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    // final isPremium = chapter.isPremium == true;
    // final isFree = chapter.isFree == true || !isPremium;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row with premium badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Chương $index: ${chapter.title}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            // if (isPremium)
                            //   Container(
                            //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            //     child: Icon(
                            //       Icons.workspace_premium,
                            //       color: AppColor.yellowText,
                            //       size: 18,
                            //     ),
                            //   ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // // Free/Premium label
                        // Text(
                        //   isFree ? 'Miễn phí' : 'Premium',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w500,
                        //     color: isFree ? AppColor.primary : AppColor.yellowText,
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        // Rating and lesson count
                        Row(
                          children: [
                            // if (chapter.rating != null) ...[
                            //   Icon(Icons.star, size: 14, color: AppColor.yellowText),
                            //   const SizedBox(width: 4),
                            //   Text(
                            //     chapter.rating!.toStringAsFixed(1),
                            //     style: TextStyle(
                            //       fontSize: 13,
                            //       color: AppColor.titleText,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            //   const SizedBox(width: 8),
                            //   Text('•', style: TextStyle(color: AppColor.statisticLabel)),
                            //   const SizedBox(width: 8),
                            // ],
                            Text(
                              '${chapter.lessons?.length ?? 0} bài học',
                              style: TextStyle(fontSize: 13, color: AppColor.statisticLabel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse button or Lock icon
                  // if (isPremium && !isFree)
                  //   Container(
                  //     width: 40,
                  //     height: 40,
                  //     decoration: BoxDecoration(color: AppColor.bgGrey, shape: BoxShape.circle),
                  //     child: Icon(Icons.lock, color: AppColor.statisticLabel, size: 20),
                  //   )
                  // else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lessons list (expandable)
          if (isExpanded && chapter.lessons != null && chapter.lessons!.isNotEmpty)
            Column(
              children: [
                const Divider(height: 1),
                ...chapter.lessons!.asMap().entries.map((entry) {
                  final lessonIndex = entry.key + 1;
                  final lesson = entry.value;
                  return Column(
                    children: [
                      LessonItemWidget(
                        index: lessonIndex,
                        lesson: lesson,
                        onTap: onLessonTap != null ? () => onLessonTap!(lesson) : null,
                      ),
                      if (lessonIndex < chapter.lessons!.length)
                        Divider(height: 1, indent: 52, color: AppColor.bgGrey),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }
}

/// Widget search header cho chapter page
class ChapterSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;

  const ChapterSearchBar({super.key, required this.controller, this.onSearch, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColor.statisticLabel, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài học...',
                hintStyle: TextStyle(color: AppColor.statisticLabel, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 14, color: AppColor.titleText),
              onSubmitted: (_) => onSearch?.call(),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, color: AppColor.statisticLabel, size: 20),
            ),
        ],
      ),
    );
  }
}
