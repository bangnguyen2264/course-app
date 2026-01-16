// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  page: (json['page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'page': instance.page,
  'total': instance.total,
};
