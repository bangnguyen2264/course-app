import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  final int id;
  @JsonKey(name: 'chapterId')
  final int? chapterId;
  final String title;
  final String? description;
  final int? position;

  Lesson({required this.id, this.chapterId, required this.title, this.description, this.position});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: parseInt(json['id']),
      chapterId: json['chapterId'] as int?,
      title: parseString(json['title']),
      description: parseStringOrNull(json['description']),
      position: json['position'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
