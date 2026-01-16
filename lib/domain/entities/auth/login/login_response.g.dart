// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: (json['id'] as num).toInt(),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'role': instance.role,
    };
