import 'package:course/app/utils/parse_utils.dart';
import 'package:course/domain/entities/user/gender.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id', fromJson: parseInt)
  final int id;
  @JsonKey(name: 'fullName', fromJson: parseString)
  final String fullName;
  @JsonKey(name: 'email', fromJson: parseString)
  final String email;
  @JsonKey(name: 'phoneNumber', fromJson: parseStringOrNull)
  final String? phomeNumber;
  @JsonKey(name: 'gender', fromJson: Gender.fromString)
  final Gender gender;
  @JsonKey(name: 'avatarUrl', fromJson: parseStringOrNull)
  final String? avatarUrl;
  @JsonKey(name: 'dob', fromJson: parseString)
  final String dob;
  @JsonKey(name: 'address', fromJson: parseStringOrNull)
  final String? address;
  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phomeNumber,
    required this.gender,
    this.avatarUrl,
    required this.dob,
    this.address,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
