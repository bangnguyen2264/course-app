// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_submission_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizSubmissionResult _$QuizSubmissionResultFromJson(
  Map<String, dynamic> json,
) => QuizSubmissionResult(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  multipleChoice: json['multipleChoice'] as bool,
  answer: json['answer'] as String,
  correctAnswers: json['correctAnswers'] as String,
);

Map<String, dynamic> _$QuizSubmissionResultToJson(
  QuizSubmissionResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'options': instance.options,
  'multipleChoice': instance.multipleChoice,
  'correctAnswers': instance.correctAnswers,
  'answer': instance.answer,
};
