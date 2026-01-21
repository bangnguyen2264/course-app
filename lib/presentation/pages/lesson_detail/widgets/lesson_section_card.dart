import 'package:course/app/resources/app_color.dart';
import 'package:course/app/widgets/app_image.dart';
import 'package:course/app/widgets/app_video_player.dart';
import 'package:course/domain/entities/lesson_section/data_type.dart';
import 'package:course/domain/entities/lesson_section/lesson_section.dart';
import 'package:flutter/material.dart';

class LessonSectionCard extends StatelessWidget {
  final LessonSection section;
  final int index;

  const LessonSectionCard({super.key, required this.section, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${section.title}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.titleText,
              height: 1.4,
            ),
          ),
          if (_hasValue(section.description)) ...[
            const SizedBox(height: 8),
            Text(
              section.description!,
              style: const TextStyle(fontSize: 14, color: AppColor.text, height: 1.6),
            ),
          ],
          const SizedBox(height: 12),
          if (_buildContent() != null) _buildContent()!,
        ],
      ),
    );
  }

  Widget? _buildContent() {
    switch (section.dataType) {
      case DataType.text:
        return _TextBlock(text: section.dataPath ?? section.content ?? '');
      case DataType.image:
        return _ImageBlock(imageUrl: section.dataPath);
      case DataType.video:
        return _VideoBlock(videoUrl: section.dataPath);
      case DataType.audio:
        return _AudioBlock(audioLabel: section.dataPath ?? 'Audio content');
      case DataType.other:
        return _InfoBlock(content: section.dataPath ?? section.description ?? '');
    }
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}

class _TextBlock extends StatelessWidget {
  final String text;

  const _TextBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Text(text, style: const TextStyle(fontSize: 14, color: AppColor.titleText, height: 1.7));
  }
}

class _ImageBlock extends StatelessWidget {
  final String? imageUrl;

  const _ImageBlock({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AppImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _VideoBlock extends StatelessWidget {
  final String? videoUrl;

  const _VideoBlock({this.videoUrl});

  @override
  Widget build(BuildContext context) {
    if (videoUrl == null || videoUrl!.isEmpty) {
      return _PlaceholderBlock(
        child: Icon(Icons.play_circle_fill, color: Colors.white.withOpacity(0.9), size: 42),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppVideoPlayer(videoUrl: videoUrl!, autoPlay: false, looping: false),
            _PlayOverlay(),
          ],
        ),
      ),
    );
  }
}

class _PlayOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1.4),
      ),
      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
    );
  }
}

class _AudioBlock extends StatelessWidget {
  final String audioLabel;

  const _AudioBlock({required this.audioLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.audiotrack, color: AppColor.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              audioLabel,
              style: const TextStyle(color: AppColor.titleText, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String content;

  const _InfoBlock({required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 32,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Expanded(
            child: Text(content, style: const TextStyle(color: AppColor.titleText, height: 1.6)),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderBlock extends StatelessWidget {
  final Widget child;

  const _PlaceholderBlock({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.gradientStart, AppColor.gradientEnd],
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
