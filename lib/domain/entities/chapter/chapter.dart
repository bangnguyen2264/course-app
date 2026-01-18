import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter {
  final int id;
  final String title;
  final String? description;
  final List<Lesson>? lessons;
  // final bool? isFree;
  // final bool? isPremium;
  // final double? rating;
  // final int? lessonCount;

  Chapter({
    required this.id,
    required this.title,
    this.description,
    this.lessons,
    // this.isFree,
    // this.isPremium,
    // this.rating,
    // this.lessonCount,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: parseInt(json['id']),
      title: parseString(json['title']),
      description: parseStringOrNull(json['description']),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      // isFree: json['is_free'] as bool?,
      // isPremium: json['is_premium'] as bool?,
      // rating: (json['rating'] as num?)?.toDouble(),
      // lessonCount: json['lesson_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  /// Lấy số lượng bài học thực tế
  // int get actualLessonCount => lessonCount ?? lessons?.length ?? 0;
}
