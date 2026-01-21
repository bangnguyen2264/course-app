import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';
import 'package:course/domain/entities/lesson_section/data_type.dart';

part 'lesson_section.g.dart';

@JsonSerializable()
class LessonSection {
  final int id;
  final DataType dataType;
  final String title;
  final String? description;
  final String? content;
  final String? dataPath;
  final int? position;

  LessonSection({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.dataPath,
    required this.dataType,
    this.position,
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    return LessonSection(
      id: parseInt(json['id']),
      title: parseString(json['title']),
      description: parseStringOrNull(json['description']),
      content: parseStringOrNull(json['content']),
      dataPath: parseStringOrNull(json['dataPath']),
      dataType: DataType.fromString(json['dataType']?.toString()),
      position: json['position'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$LessonSectionToJson(this);
}
