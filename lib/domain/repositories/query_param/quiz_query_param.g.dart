// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_query_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$QuizQueryParamToJson(QuizQueryParam instance) =>
    <String, dynamic>{
      'page': ?instance.page,
      'entry': ?instance.entry,
      'field': instance.field,
      'sort': BaseQueryParams.sortOrderToJson(instance.sort),
      'search': ?instance.search,
      'subjectId': ?instance.subjectId,
      'multipleChoice': ?instance.multipleChoice,
      'examId': ?instance.examId,
    };
