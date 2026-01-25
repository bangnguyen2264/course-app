import 'package:course/domain/quiz/quiz.dart';
import 'package:course/domain/quiz/quiz_review.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_submission_result.g.dart';

@JsonSerializable()
class QuizSubmissionResult extends QuizReview {
  final String answer;

  QuizSubmissionResult({
    required super.id,
    required super.question,
    required super.options,
    required super.multipleChoice,
    required this.answer,
    required super.correctAnswers,
  });

  factory QuizSubmissionResult.fromJson(Map<String, dynamic> json) => _$QuizSubmissionResultFromJson(json);
  Map<String, dynamic> toJson() => _$QuizSubmissionResultToJson(this);
}
