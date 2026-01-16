// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonSection _$LessonSectionFromJson(Map<String, dynamic> json) =>
    LessonSection(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      dataPath: json['dataPath'] as String?,
      dataType: $enumDecode(_$DataTypeEnumMap, json['dataType']),
    );

Map<String, dynamic> _$LessonSectionToJson(LessonSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataType': _$DataTypeEnumMap[instance.dataType]!,
      'title': instance.title,
      'description': instance.description,
      'dataPath': instance.dataPath,
    };

const _$DataTypeEnumMap = {
  DataType.text: 'TEXT',
  DataType.image: 'IMAGE',
  DataType.video: 'VIDEO',
  DataType.audio: 'AUDIO',
  DataType.other: 'OTHER',
};
