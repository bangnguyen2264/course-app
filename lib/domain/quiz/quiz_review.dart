import 'package:course/domain/quiz/quiz.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quiz_review.g.dart';

@JsonSerializable()
class QuizReview extends Quiz {
  final String correctAnswers;

  QuizReview({
    required super.id,
    required super.question,
    required super.options,
    required super.multipleChoice,
    required this.correctAnswers,
  });

  factory QuizReview.fromJson(Map<String, dynamic> json) => _$QuizReviewFromJson(json);
   Map<String, dynamic> toJson() => _$QuizReviewToJson(this);
}