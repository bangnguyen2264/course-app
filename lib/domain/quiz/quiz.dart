import 'package:json_annotation/json_annotation.dart';

part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  final int id;
  final String question;
  final List<String> options;
  final bool multipleChoice;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    this.multipleChoice = false,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);

}