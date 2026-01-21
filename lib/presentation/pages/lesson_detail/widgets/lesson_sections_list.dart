import 'package:course/domain/entities/lesson_section/lesson_section.dart';
import 'package:course/presentation/pages/lesson_detail/widgets/lesson_section_card.dart';
import 'package:flutter/material.dart';

class LessonSectionsSliverList extends StatelessWidget {
  final List<LessonSection> sections;

  const LessonSectionsSliverList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => LessonSectionCard(section: sections[index], index: index + 1),
        childCount: sections.length,
      ),
    );
  }
}
