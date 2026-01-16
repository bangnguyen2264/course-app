import 'package:course/domain/entities/user/gender.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final Gender gender;
  @JsonKey(toJson: _dateToJson)
  final DateTime dob;
  final String address;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.gender,
    required this.dob,
    required this.address,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  static String _dateToJson(DateTime date) {
    return date.toIso8601String();
  }
}
