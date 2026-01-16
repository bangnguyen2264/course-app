// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phoneNumber: json['phoneNumber'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      dob: DateTime.parse(json['dob'] as String),
      address: json['address'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'gender': _$GenderEnumMap[instance.gender]!,
      'dob': RegisterRequest._dateToJson(instance.dob),
      'address': instance.address,
    };

const _$GenderEnumMap = {Gender.male: 'MALE', Gender.female: 'FEMALE'};
