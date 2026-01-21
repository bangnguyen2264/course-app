import 'package:course/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChapterAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final String title;
  final String? subtitle;
  final VoidCallback? onSearch;

  const ChapterAppBar({
    super.key,
    required this.onBack,
    required this.title,
    this.subtitle,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(onBack: onBack, title: title, subtitle: subtitle, onSearch: onSearch);
  }
}
