
import 'package:json_annotation/json_annotation.dart';
part 'exam.g.dart';

@JsonSerializable()
class Exam {
  final int id;
  final String title;
  final int duration;

  Exam({
    required this.id,
    required this.title,
    required this.duration,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);

}