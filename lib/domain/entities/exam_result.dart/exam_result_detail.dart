import 'package:course/domain/entities/exam_result.dart/exam_result.dart';
import 'package:course/domain/quiz/quiz.dart';
import 'package:course/domain/quiz/quiz_submission_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam_result_detail.g.dart';

@JsonSerializable()
class ExamResultDetail extends ExamResult {

  final List<QuizSubmissionResult> quizResultSubmissionList;

  ExamResultDetail({
    required super.id,
    required super.examId,
    required super.examTitle,
    required super.score,
    required super.correct,
    required super.incorrect,
    required super.timeTaken,
    required this.quizResultSubmissionList,
    required super.createdAt,
  });

  factory ExamResultDetail.fromJson(Map<String, dynamic> json) => _$ExamResultDetailFromJson(json); 
  Map<String, dynamic> toJson() => _$ExamResultDetailToJson(this);
}


