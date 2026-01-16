import 'dart:async';

import 'package:course/app/di/dependency_injection.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/user/user.dart';
import 'package:course/domain/usecases/get_user_usecase.dart';
import 'package:course/presentation/controllers/home/home_controller.dart';
import 'package:course/presentation/controllers/home/home_state.dart';
import 'package:course/presentation/widgets/profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final homeController = ref.read(homeControllerProvider.notifier);

    // State cho user (local state)
    final user = useState<User?>(null);
    final isLoadingUser = useState(true);
    final searchController = useTextEditingController();
    final debounceTimer = useRef<Timer?>(null);

    // Load subjects khi widget được mount
    useEffect(() {
      Future.microtask(() => homeController.loadSubjects());
      return null;
    }, []);

    // Debounce search khi text thay đổi
    useEffect(() {
      void onSearchChanged() {
        debounceTimer.value?.cancel();
        debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
          homeController.search(searchController.text);
        });
      }

      searchController.addListener(onSearchChanged);
      return () {
        debounceTimer.value?.cancel();
        searchController.removeListener(onSearchChanged);
      };
    }, [searchController]);

    // Load user khi widget được mount
    useEffect(() {
      Future.microtask(() async {
        try {
          final loadedUser = await getIt<GetUserUseCase>().execute();
          user.value = loadedUser;
        } catch (e) {
          debugPrint('Error loading user: $e');
        } finally {
          isLoadingUser.value = false;
        }
      });
      return null;
    }, []);

    // Listen for error messages
    ref.listen<HomeState>(homeControllerProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        homeController.clearError();
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header với Avatar, Welcome, Notification
              _buildHeader(context, user.value, isLoadingUser.value),
              // Body content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.scaffoldBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () => homeController.refresh(),
                      child: _buildBody(context, ref, homeState, searchController),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    HomeState state,
    TextEditingController searchController,
  ) {
    final homeController = ref.read(homeControllerProvider.notifier);

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
              onPressed: () => homeController.loadSubjects(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          homeController.loadMoreSubjects();
        }
        return false;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh tìm kiếm Subject
            _buildSearchBar(searchController, ref),
            const SizedBox(height: 20),
            // Recommendation Section
            _buildRecommendationSection(context, ref, state),
            // Loading more indicator
            if (state.isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          ProfileAvatar(avatarUrl: user?.avatarUrl, size: 50),
          const SizedBox(width: 12),
          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  isLoading ? '...' : (user?.fullName ?? 'Guest'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Notification icon
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                // TODO: Navigate to notifications
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController controller, WidgetRef ref) {
    final homeController = ref.read(homeControllerProvider.notifier);
    final homeState = ref.watch(homeControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm môn học...',
          hintStyle: TextStyle(color: AppColor.grey.withOpacity(0.6)),
          prefixIcon: const Icon(Icons.search, color: AppColor.primary),
          suffixIcon: homeState.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColor.grey),
                  onPressed: () {
                    controller.clear();
                    homeController.clearSearch();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(BuildContext context, WidgetRef ref, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị tiêu đề dựa trên trạng thái search
        if (state.isSearching)
          Row(
            children: [
              Text(
                'Kết quả tìm kiếm: "${state.searchQuery}"',
                style: const TextStyle(
                  color: AppColor.titleText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${state.total} kết quả',
                style: TextStyle(color: AppColor.statisticLabel, fontSize: 14),
              ),
            ],
          )
        else
          Row(
            children: [
              const Text(
                'Môn học',
                style: TextStyle(
                  color: AppColor.titleText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${state.total} môn',
                style: TextStyle(color: AppColor.statisticLabel, fontSize: 14),
              ),
            ],
          ),

        const SizedBox(height: 16),
        // Hiển thị subjects từ state
        if (state.subjects.isEmpty && !state.isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                state.isSearching ? 'Không tìm thấy môn học phù hợp' : 'Không có môn học nào',
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.subjects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final subject = state.subjects[index];
              return _buildCourseCard(
                title: subject.name,
                price: 'Miễn phí',
                rating: 4.5,
                author: 'By Admin',
                level: 'All Level',
              );
            },
          ),
      ],
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String price,
    required double rating,
    required String author,
    required String level,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.titleText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColor.titleText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColor.yellowText, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: AppColor.titleText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $author • $level',
                      style: TextStyle(color: AppColor.statisticLabel, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Course image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColor.notification.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
