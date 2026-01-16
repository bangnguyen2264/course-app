import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter {
  final int id;
  final String title;
  final String? description;

  Chapter({required this.id, required this.title, this.description});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: parseInt(json['id']),
      title: parseString(json['title']),
      description: parseStringOrNull(json['description']),
    );
  }

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
