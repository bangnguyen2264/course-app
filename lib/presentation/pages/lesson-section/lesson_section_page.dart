import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LessonSectionPage extends HookConsumerWidget {
  final int lessonId;

  const LessonSectionPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Sections for Lesson $lessonId'),
      ),
      body: Center(
        child: Text('Lesson Sections for Lesson $lessonId - TODO'),
      ),
    );
  }
}