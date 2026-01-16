import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  final int id;
  final String title;
  final String? description;

  Lesson({required this.id, required this.title, this.description});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: parseInt(json['id']),
      title: parseString(json['title']),
      description: parseStringOrNull(json['description']),
    );
  }

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
