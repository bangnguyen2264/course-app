import 'package:course/domain/quiz/quiz.dart';
import 'package:course/domain/quiz/quiz_submission_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam_result.g.dart';

@JsonSerializable()
class ExamResult {
  final int id;
  final int examId;
  final String examTitle;
  final double score;
  final int correct;
  final int incorrect;
  final int timeTaken;
  final List<QuizSubmissionResult> quizResultSubmissionList;
  final DateTime createdAt;

  ExamResult({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.score,
    required this.correct,
    required this.incorrect,
    required this.timeTaken,
    required this.quizResultSubmissionList,
    required this.createdAt,
  });


  factory ExamResult.fromJson(Map<String, dynamic> json) => _$ExamResultFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultToJson(this);
}


