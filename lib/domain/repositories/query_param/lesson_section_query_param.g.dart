// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_section_query_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$LessonSectionQueryParamsToJson(
  LessonSectionQueryParams instance,
) => <String, dynamic>{
  'page': ?instance.page,
  'entry': ?instance.entry,
  'field': instance.field,
  'sort': BaseQueryParams.sortOrderToJson(instance.sort),
  'search': ?instance.search,
  'lessonId': ?instance.lessonId,
  'dataType': ?_$DataTypeEnumMap[instance.dataType],
};

const _$DataTypeEnumMap = {
  DataType.text: 'TEXT',
  DataType.image: 'IMAGE',
  DataType.video: 'VIDEO',
  DataType.audio: 'AUDIO',
  DataType.other: 'OTHER',
};
