import 'package:course/app/resources/app_color.dart';
import 'package:course/app/widgets/app_image.dart';
import 'package:course/app/widgets/app_video_player.dart';
import 'package:course/domain/entities/lesson_section/data_type.dart';
import 'package:course/domain/entities/lesson_section/lesson_section.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị một section trong bài học
class LessonSectionCard extends StatelessWidget {
  final LessonSection section;
  final int index;

  const LessonSectionCard({super.key, required this.section, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          // Content based on dataType
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.titleText,
                  ),
                ),
                if (section.description != null && section.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    section.description!,
                    style: TextStyle(fontSize: 14, color: AppColor.statisticLabel),
                  ),
                ],
              ],
            ),
          ),
          // Type icon
          _buildTypeIcon(),
        ],
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (section.dataType) {
      case DataType.text:
        icon = Icons.article_outlined;
        color = Colors.blue;
        break;
      case DataType.image:
        icon = Icons.image_outlined;
        color = Colors.green;
        break;
      case DataType.video:
        icon = Icons.play_circle_outline;
        color = Colors.red;
        break;
      case DataType.audio:
        icon = Icons.audiotrack_outlined;
        color = Colors.purple;
        break;
      case DataType.other:
        icon = Icons.attach_file;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (section.dataType) {
      case DataType.text:
        return _buildTextContent();
      case DataType.image:
        return _buildImageContent();
      case DataType.video:
        return _buildVideoContent();
      case DataType.audio:
        return _buildAudioContent();
      case DataType.other:
        return _buildOtherContent();
    }
  }

  Widget _buildTextContent() {
    if (section.dataPath == null || section.dataPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColor.bgGrey, borderRadius: BorderRadius.circular(12)),
        child: Text(
          section.dataPath!,
          style: const TextStyle(fontSize: 14, color: AppColor.titleText, height: 1.6),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (section.dataPath == null || section.dataPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AppImage(
          imageUrl: section.dataPath,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (section.dataPath == null || section.dataPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: AppVideoPlayer(videoUrl: section.dataPath!, autoPlay: false, looping: false),
    );
  }

  Widget _buildAudioContent() {
    // Hiện tại không cần audio, hiển thị placeholder
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.audiotrack, color: Colors.purple),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                section.dataPath ?? 'Audio content',
                style: const TextStyle(color: Colors.purple),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherContent() {
    if (section.dataPath == null || section.dataPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.attach_file, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                section.dataPath!,
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget loading skeleton cho section
class LessonSectionSkeleton extends StatelessWidget {
  const LessonSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSkeletonBox(28, 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(double.infinity, 16),
                    const SizedBox(height: 8),
                    _buildSkeletonBox(150, 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSkeletonBox(double.infinity, 100),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
    );
  }
}
