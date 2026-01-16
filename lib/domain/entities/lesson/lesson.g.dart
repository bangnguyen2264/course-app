// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
};
