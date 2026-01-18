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
            // Header
            _buildHeader(context, state),
            // Body
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

  Widget _buildHeader(BuildContext context, LessonDetailState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.bgGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColor.titleText),
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.titleText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    lesson.description!,
                    style: TextStyle(fontSize: 13, color: AppColor.statisticLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Sections count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.sections.length} nội dung',
              style: TextStyle(fontSize: 12, color: AppColor.primary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    LessonDetailState state,
    LessonDetailController controller,
  ) {
    if (state.isLoading && state.sections.isEmpty) {
      return _buildLoadingSkeleton();
    }

    if (state.hasError && state.sections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Có lỗi xảy ra',
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
      );
    }

    if (state.sections.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Chưa có nội dung', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          controller.loadMoreSections();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.sections.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.sections.length) {
            return const Center(
              child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
            );
          }

          final section = state.sections[index];
          return LessonSectionCard(section: section, index: index + 1);
        },
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => const LessonSectionSkeleton(),
    );
  }
}
