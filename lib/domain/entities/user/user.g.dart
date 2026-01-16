// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: parseInt(json['id']),
  fullName: parseString(json['fullName']),
  email: parseString(json['email']),
  phomeNumber: parseStringOrNull(json['phoneNumber']),
  gender: Gender.fromString(json['gender'] as String?),
  avatarUrl: parseStringOrNull(json['avatarUrl']),
  dob: parseString(json['dob']),
  address: parseStringOrNull(json['address']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phoneNumber': instance.phomeNumber,
  'gender': _$GenderEnumMap[instance.gender]!,
  'avatarUrl': instance.avatarUrl,
  'dob': instance.dob,
  'address': instance.address,
};

const _$GenderEnumMap = {Gender.male: 'MALE', Gender.female: 'FEMALE'};
