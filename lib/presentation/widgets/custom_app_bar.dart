import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom App Bar dùng chung cho các màn hình
/// Giữ nguyên UI cũ nhưng chuyển sang dùng AppBar chuẩn
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback khi tap back button (bắt buộc)
  final VoidCallback? onBack;

  /// Tiêu đề chính
  final String title;

  /// Tiêu đề phụ (tùy chọn)
  final String? subtitle;

  /// Callback khi tap search button (tùy chọn)
  final VoidCallback? onSearch;

  final bool centerTitle;

  final Widget? leading;

  /// Các action buttons tùy chỉnh ở phía bên phải (tùy chọn)
  final List<CustomAppBarAction>? actions;

  /// Có hiển thị back button không (mặc định: true)
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.onBack,
    required this.title,
    this.centerTitle = true,
    this.subtitle,
    this.onSearch,
    this.leading,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: centerTitle,
        // Padding giống UI cũ
        titleSpacing: 0,
        leading: showBackButton
            ? _ActionButton(icon: Icons.arrow_back_ios_new, onTap: onBack ?? () => context.pop())
            : leading,
        title: Column(
          crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.titleText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle ?? '',
              style: const TextStyle(fontSize: 13, color: AppColor.statisticLabel),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

        // Custom actions
        actions: [
          if (onSearch != null) _ActionButton(icon: Icons.search, onTap: onSearch),
          if (actions != null)
            ...actions!.map(
              (action) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _ActionButton(icon: action.icon, onTap: action.onTap),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Model cho custom action button
class CustomAppBarAction {
  final IconData icon;
  final VoidCallback? onTap;

  const CustomAppBarAction({required this.icon, this.onTap});
}

/// Action button tái sử dụng (giữ nguyên UI cũ)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.bgGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18, color: AppColor.titleText),
        ),
      ),
    );
  }
}
