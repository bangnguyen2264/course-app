// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
};
