import 'dart:async';

import 'package:course/app/constants/app_routes.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/presentation/controllers/chapter/chapter_controller.dart';
import 'package:course/presentation/controllers/chapter/chapter_state.dart';
import 'package:course/presentation/pages/chapter/widgets/chapter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChapterPage extends HookConsumerWidget {
  final Subject subject;

  const ChapterPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterState = ref.watch(chapterControllerProvider);
    final chapterController = ref.read(chapterControllerProvider.notifier);

    // State cho search
    final searchController = useTextEditingController();
    final isSearching = useState(false);
    final debounceTimer = useRef<Timer?>(null);

    // Initialize và load chapters khi widget được mount
    useEffect(() {
      Future.microtask(() {
        chapterController.initialize(subject);
        chapterController.loadChapters(subjectId: subject.id);
      });
      return () {
        debounceTimer.value?.cancel();
      };
    }, [subject.id]);

    // Debounce search
    useEffect(() {
      void onSearchChanged() {
        debounceTimer.value?.cancel();
        debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
          chapterController.search(searchController.text);
        });
      }

      searchController.addListener(onSearchChanged);
      return () {
        debounceTimer.value?.cancel();
        searchController.removeListener(onSearchChanged);
      };
    }, [searchController]);

    // Listen for error messages
    ref.listen<ChapterState>(chapterControllerProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        chapterController.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            ChapterAppBar(
              onBack: () => context.pop(),
              title: subject.name,
              subtitle: '${chapterState.chapterCount} chương',
              onSearch: null, // Disabled search for now
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => chapterController.refresh(),
                child: _buildBody(context, ref, chapterState, chapterController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ChapterState state,
    ChapterController controller,
  ) {
    if (state.isLoading && state.chapters.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && state.chapters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColor.statisticLabel),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Có lỗi xảy ra',
              style: TextStyle(color: AppColor.statisticLabel),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.loadChapters(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state.chapters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: AppColor.statisticLabel),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty ? 'Không tìm thấy chương nào' : 'Chưa có chương nào',
              style: TextStyle(fontSize: 16, color: AppColor.statisticLabel),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          controller.loadMoreChapters();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.chapters.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.chapters.length) {
            return const Center(
              child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
            );
          }

          final chapter = state.chapters[index];
          final chapterIndex = index + 1;

          return ChapterCardWidget(
            index: chapterIndex,
            chapter: chapter,
            isExpanded: state.isChapterExpanded(chapter.id),
            onToggle: () => controller.toggleChapterExpanded(chapter.id),
            onLessonTap: (lesson) {
              context.push(AppRoutes.lessonSection, extra: lesson);
            },
          );
        },
      ),
    );
  }
}
