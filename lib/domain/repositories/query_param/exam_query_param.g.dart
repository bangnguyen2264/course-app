// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_query_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ExamQueryParamToJson(ExamQueryParam instance) =>
    <String, dynamic>{
      'page': ?instance.page,
      'entry': ?instance.entry,
      'field': instance.field,
      'sort': BaseQueryParams.sortOrderToJson(instance.sort),
      'search': ?instance.search,
      'subjectId': ?instance.subjectId,
      'duration': ?_$ExamDurationEnumMap[instance.duration],
    };

const _$ExamDurationEnumMap = {
  ExamDuration.m10: 'MIN_10',
  ExamDuration.m15: 'MIN_15',
  ExamDuration.m30: 'MIN_30',
  ExamDuration.m45: 'MIN_45',
  ExamDuration.m60: 'MIN_60',
  ExamDuration.m90: 'MIN_90',
  ExamDuration.m120: 'MIN_120',
};
