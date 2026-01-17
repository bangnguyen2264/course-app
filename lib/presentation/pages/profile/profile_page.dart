import 'package:course/app/constants/app_routes.dart';
import 'package:course/presentation/controllers/profile/profile_state.dart';
import 'package:course/presentation/controllers/profile/profile_controller.dart';
import 'package:course/presentation/pages/profile/widgets/logout_confirm_dialog.dart';
import 'package:course/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:course/presentation/pages/profile/widgets/profile_info_card.dart';
import 'package:course/presentation/pages/profile/widgets/profile_states_widget.dart';
import 'package:course/presentation/pages/profile/widgets/settings_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final viewModel = ref.read(profileControllerProvider.notifier);

    // Load user data on first build
    useEffect(() {
      Future.microtask(() => viewModel.loadUser());
      return null;
    }, []);

    // Listen for error messages
    ref.listen<ProfileState>(profileControllerProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        viewModel.clearError();
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: _buildBody(context, ref, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ProfileState state) {
    final viewModel = ref.read(profileControllerProvider.notifier);

    if (state.isLoading && state.user == null) {
      return const ProfileLoadingWidget();
    }

    if (state.hasError && state.user == null) {
      return ProfileErrorWidget(
        message: state.errorMessage ?? 'Không thể tải thông tin',
        onRetry: () => viewModel.loadUser(),
      );
    }

    final user = state.user;
    if (user == null) {
      return const ProfileLoadingWidget();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar section
          _buildAvatarSection(context, user.fullName, user.email, user.avatarUrl),
          const SizedBox(height: 24),

          // User info card
          ProfileInfoCard(user: user),
          const SizedBox(height: 16),

          // Settings menu
          _buildSettingsMenu(context, ref),
          const SizedBox(height: 16),

          // Logout section
          _buildLogoutSection(context, ref, state),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(
    BuildContext context,
    String fullName,
    String email,
    String? avatarUrl,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ProfileAvatar(
          avatarUrl: avatarUrl,
          size: 100,
          onTap: () {
            // TODO: Change avatar
          },
        ),
        const SizedBox(height: 16),
        Text(fullName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          email,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildSettingsMenu(BuildContext context, WidgetRef ref) {
    return SettingsMenuCard(
      title: 'Cài đặt',
      items: [
        SettingsMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Thông báo',
          subtitle: 'Quản lý thông báo ứng dụng',
          onTap: () {
            // TODO: Navigate to notifications settings
          },
        ),
        SettingsMenuItem(
          icon: Icons.lock_outline,
          title: 'Đổi mật khẩu',
          subtitle: 'Cập nhật mật khẩu bảo mật',
          onTap: () {
            // TODO: Navigate to change password
          },
        ),
        SettingsMenuItem(
          icon: Icons.palette_outlined,
          title: 'Giao diện',
          subtitle: 'Chế độ sáng/tối',
          onTap: () {
            // TODO: Navigate to theme settings
          },
        ),
        SettingsMenuItem(
          icon: Icons.language_outlined,
          title: 'Ngôn ngữ',
          subtitle: 'Tiếng Việt',
          onTap: () {
            // TODO: Navigate to language settings
          },
        ),
        SettingsMenuItem(
          icon: Icons.help_outline,
          title: 'Trợ giúp & Hỗ trợ',
          onTap: () {
            // TODO: Navigate to help
          },
        ),
        SettingsMenuItem(
          icon: Icons.info_outline,
          title: 'Về ứng dụng',
          subtitle: 'Phiên bản 1.0.0',
          onTap: () {
            // TODO: Show about dialog
          },
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context, WidgetRef ref, ProfileState state) {
    final viewModel = ref.read(profileControllerProvider.notifier);

    return SettingsMenuCard(
      items: [
        SettingsMenuItem(
          icon: Icons.logout,
          title: 'Đăng xuất',
          isDestructive: true,
          trailing: state.isLoggingOut
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          onTap: state.isLoggingOut
              ? null
              : () async {
                  final confirmed = await LogoutConfirmDialog.show(context);
                  if (confirmed == true) {
                    final success = await viewModel.logout();
                    if (success && context.mounted) {
                      context.go(AppRoutes.getStarted);
                    }
                  }
                },
        ),
      ],
    );
  }
}
