// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResult _$ExamResultFromJson(Map<String, dynamic> json) => ExamResult(
  id: (json['id'] as num).toInt(),
  examId: (json['examId'] as num).toInt(),
  examTitle: json['examTitle'] as String,
  score: (json['score'] as num).toDouble(),
  correct: (json['correct'] as num).toInt(),
  incorrect: (json['incorrect'] as num).toInt(),
  timeTaken: (json['timeTaken'] as num).toInt(),
  quizResultSubmissionList: (json['quizResultSubmissionList'] as List<dynamic>)
      .map((e) => QuizSubmissionResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ExamResultToJson(ExamResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'examId': instance.examId,
      'examTitle': instance.examTitle,
      'score': instance.score,
      'correct': instance.correct,
      'incorrect': instance.incorrect,
      'timeTaken': instance.timeTaken,
      'quizResultSubmissionList': instance.quizResultSubmissionList,
      'createdAt': instance.createdAt.toIso8601String(),
    };
