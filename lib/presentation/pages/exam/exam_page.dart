import 'dart:async';

import 'package:course/app/constants/app_routes.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/presentation/controllers/exam/exam_controller.dart';
import 'package:course/presentation/controllers/exam/exam_state.dart';
import 'package:course/presentation/pages/exam/widgets/exam_widgets.dart';
import 'package:course/presentation/widgets/custom_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamPage extends HookConsumerWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examState = ref.watch(examControllerProvider);
    final examController = ref.read(examControllerProvider.notifier);

    // State cho search
    final searchController = useTextEditingController();
    final debounceTimer = useRef<Timer?>(null);

    // Load subjects khi widget được mount
    useEffect(() {
      Future.microtask(() => examController.loadSubjects());
      return null;
    }, []);

    // Debounce search khi text thay đổi
    useEffect(() {
      void onSearchChanged() {
        debounceTimer.value?.cancel();
        debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
          examController.search(searchController.text);
        });
      }

      searchController.addListener(onSearchChanged);
      return () {
        debounceTimer.value?.cancel();
        searchController.removeListener(onSearchChanged);
      };
    }, [searchController]);

    // Listen for error messages
    ref.listen<ExamState>(examControllerProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        examController.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Body content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => examController.refresh(),
                child: _buildBody(context, ref, examState, searchController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'CURRICULUM 2025',
                style: TextStyle(
                  color: AppColor.primary.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.search, color: AppColor.titleText),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Select Subject',
            style: TextStyle(color: AppColor.titleText, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ExamState state,
    TextEditingController searchController,
  ) {
    final examController = ref.read(examControllerProvider.notifier);

    if (state.isLoading && state.subjects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && state.subjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage ?? 'Có lỗi xảy ra'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => examController.loadSubjects(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          examController.loadMoreSubjects();
        }
        return false;
      },
      child: CustomGridView(
        items: state.subjects,
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        isLoadingMore: state.isLoadingMore,
        itemBuilder: (context, subject, index) {
          return SubjectGridCard(
            subject: subject,
            onTap: () {
              context.push(AppRoutes.examList, extra: subject);
            },
          );
        },
        footer: Column(
          children: [
            // Daily Tip Section
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.titleText,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Tip',
                          style: TextStyle(
                            color: AppColor.primary.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Focus on Weaknesses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lightbulb_outline, color: AppColor.primary, size: 32),
                  ),
                ],
              ),
            ),
            // Bottom spacing for navigation bar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
