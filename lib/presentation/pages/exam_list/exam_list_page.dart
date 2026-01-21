import 'dart:async';

import 'package:course/app/constants/app_routes.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/presentation/controllers/exam_list/exam_list_controller.dart';
import 'package:course/presentation/controllers/exam_list/exam_list_state.dart';
import 'package:course/presentation/pages/exam_list/widgets/exam_list_widgets.dart';
import 'package:course/presentation/widgets/custom_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamListPage extends HookConsumerWidget {
  final Subject subject;

  const ExamListPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examListState = ref.watch(examListControllerProvider);
    final examListController = ref.read(examListControllerProvider.notifier);

    // State cho search
    final searchController = useTextEditingController();
    final debounceTimer = useRef<Timer?>(null);

    // Initialize và load exams khi widget được mount
    useEffect(() {
      Future.microtask(() {
        examListController.initialize(subject);
        examListController.loadExams(subjectId: subject.id);
      });
      return () {
        debounceTimer.value?.cancel();
      };
    }, [subject.id]);

    // Debounce search khi text thay đổi
    useEffect(() {
      void onSearchChanged() {
        debounceTimer.value?.cancel();
        debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
          examListController.search(searchController.text);
        });
      }

      searchController.addListener(onSearchChanged);
      return () {
        debounceTimer.value?.cancel();
        searchController.removeListener(onSearchChanged);
      };
    }, [searchController]);

    // Listen for error messages
    ref.listen<ExamListState>(examListControllerProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        examListController.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            ExamListHeader(
              subjectName: subject.name,
              examCount: examListState.total,
              onBack: () => context.pop(),
              onSearch: null, // TODO: Implement search UI
            ),
            // Body content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => examListController.refresh(),
                child: _buildBody(context, ref, examListState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ExamListState state) {
    final examListController = ref.read(examListControllerProvider.notifier);

    if (state.isLoading && state.exams.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && state.exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage ?? 'Có lỗi xảy ra'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => examListController.loadExams(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state.exams.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Chưa có đề thi nào', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          examListController.loadMoreExams();
        }
        return false;
      },
      child: CustomGridView(
        items: state.exams,
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: const EdgeInsets.all(20),
        isLoadingMore: state.isLoadingMore,
        itemBuilder: (context, exam, index) {
          return ExamCard(
            exam: exam,
            onTap: () {
              // Navigate to exam take page
              context.push(AppRoutes.examTake, extra: exam);
            },
          );
        },
        footer: const SizedBox(height: 80), // Spacing for bottom navigation
      ),
    );
  }
}
