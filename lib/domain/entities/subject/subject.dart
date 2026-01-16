import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';

part 'subject.g.dart';

@JsonSerializable()
class Subject {
  final int id;
  final String name;
  final String? description;

  Subject({required this.id, required this.name, this.description});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      description: parseStringOrNull(json['description']),
    );
  }

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}
