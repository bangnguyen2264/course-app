import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final int id;
  final String token;
  final String refreshToken;
  final String role;
  LoginResponse({
    required this.id,
    required this.token,
    required this.refreshToken,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
