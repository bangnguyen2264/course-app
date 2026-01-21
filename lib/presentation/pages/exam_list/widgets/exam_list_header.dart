import 'package:course/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

/// Widget header cho màn danh sách exam
class ExamListHeader extends StatelessWidget {
  final String subjectName;
  final int examCount;
  final VoidCallback? onBack;
  final VoidCallback? onSearch;

  const ExamListHeader({
    super.key,
    required this.subjectName,
    required this.examCount,
    this.onBack,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: CustomAppBar(
        onBack: onBack ?? () {},
        title: subjectName,
        subtitle: '$examCount đề thi',
        onSearch: onSearch,
        showBackButton: onBack != null,
      ),
    );
  }
}
