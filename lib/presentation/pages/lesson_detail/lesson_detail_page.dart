import 'dart:math';

import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:course/presentation/controllers/lesson_detail/lesson_detail_controller.dart';
import 'package:course/presentation/controllers/lesson_detail/lesson_detail_state.dart';
import 'package:course/presentation/pages/lesson_detail/widgets/lesson_section_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LessonDetailPage extends HookConsumerWidget {
  final Lesson lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonDetailControllerProvider);
    final controller = ref.read(lessonDetailControllerProvider.notifier);

    // Initialize và load sections khi widget được mount
    useEffect(() {
      Future.microtask(() {
        controller.initialize(lesson);
        controller.loadSections(lessonId: lesson.id);
      });
      return null;
    }, [lesson.id]);

    // Listen for error messages
    ref.listen<LessonDetailState>(lessonDetailControllerProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        controller.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            LessonDetailAppBar(onBack: () => context.pop(), onBookmark: () {}, onShare: () {}),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refresh(),
                child: _buildBody(context, state, controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    LessonDetailState state,
    LessonDetailController controller,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          controller.loadMoreSections();
        }
        return false;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: LessonDetailHeader(
              lesson: lesson,
              sectionCount: state.sections.length,
              estimatedMinutes: _estimatedMinutes(state.sections.length),
              chapterLabel: _chapterLabel(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 4)),
          if (state.isLoading && state.sections.isEmpty)
            _buildLoadingSliver()
          else if (state.hasError && state.sections.isEmpty)
            _buildErrorSliver(controller, state.errorMessage)
          else if (state.sections.isEmpty)
            _buildEmptySliver()
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: LessonSectionsSliverList(sections: state.sections),
            ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          if (state.sections.isNotEmpty)
            SliverToBoxAdapter(
              child: LessonCompleteFooter(
                onComplete: () {},
                nextLabel: 'Next: Balanced Trees Quiz',
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
    );
  }

  SliverList _buildLoadingSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: LessonSectionSkeleton(),
        ),
        childCount: 3,
      ),
    );
  }

  SliverFillRemaining _buildErrorSliver(LessonDetailController controller, String? errorMessage) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Có lỗi xảy ra',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.loadSections(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildEmptySliver() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Chưa có nội dung', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  int _estimatedMinutes(int sectionCount) {
    if (sectionCount <= 0) return 12;
    return max(5, sectionCount * 3);
  }

  String _chapterLabel() {
    if (lesson.position != null) return 'Chapter ${lesson.position}';
    if (lesson.chapterId != null) return 'Chapter ${lesson.chapterId}';
    return 'Chapter';
  }
}
