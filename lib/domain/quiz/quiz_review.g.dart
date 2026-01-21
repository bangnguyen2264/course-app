// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizReview _$QuizReviewFromJson(Map<String, dynamic> json) => QuizReview(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  multipleChoice: json['multipleChoice'] as bool,
  correctAnswers: json['correctAnswers'] as String,
);

Map<String, dynamic> _$QuizReviewToJson(QuizReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'multipleChoice': instance.multipleChoice,
      'correctAnswers': instance.correctAnswers,
    };
