import 'package:json_annotation/json_annotation.dart';
import 'package:course/app/utils/parse_utils.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final List<T> data;
  final int page;
  final int total;

  ApiResponse({required this.data, required this.page, required this.total});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResponse<T>(
      data: parseList(json['data'], fromJsonT),
      page: parseInt(json['page']),
      total: parseInt(json['total']),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
