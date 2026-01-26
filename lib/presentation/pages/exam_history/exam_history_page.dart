import 'package:course/app/constants/app_routes.dart';
import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/exam_history_card.dart';
import '../../controllers/exam_history/exam_history_controller.dart';

class ExamHistoryPage extends HookConsumerWidget {
  final Exam exam;
  const ExamHistoryPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examHistoryControllerProvider);
    final controller = ref.read(examHistoryControllerProvider.notifier);
    final scrollController = useScrollController();

    // Load data on mount (avoid updating provider during build)
    useEffect(() {
      Future.microtask(() async {
        controller.initialize(examId: exam.id);
        await controller.loadExamResults();
      });
      return null;
    }, [exam.id]);
    // Pagination: load more when scroll to bottom
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          controller.loadMoreExamResults();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    if (state.isLoading && state.examResults.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.hasError && state.examResults.isEmpty) {
      return Scaffold(body: Center(child: Text(state.errorMessage ?? 'Có lỗi xảy ra')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(exam.title), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refresh(),
                child: (!state.isLoading && state.examResults.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'Bạn chưa từng làm đề này',
                              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hãy nhấn "Bắt đầu làm bài" để thử sức với đề thi "${exam.title}"!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.examResults.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < state.examResults.length) {
                            final result = state.examResults[index];
                            return ExamHistoryCard(result: result);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pushReplacement(AppRoutes.examTake, extra: exam),
                  child: const Text('Bắt đầu làm bài'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
