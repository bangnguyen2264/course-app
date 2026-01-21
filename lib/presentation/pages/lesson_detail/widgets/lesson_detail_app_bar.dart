import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';

class LessonDetailAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  const LessonDetailAppBar({super.key, required this.onBack, this.onBookmark, this.onShare});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _ActionButton(icon: Icons.arrow_back_ios_new, onTap: onBack),
          const Spacer(),
          _ActionButton(icon: Icons.bookmark_border, onTap: onBookmark),
          const SizedBox(width: 12),
          _ActionButton(icon: Icons.share_outlined, onTap: onShare),
        ],
      ),
    );
  }
}

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
