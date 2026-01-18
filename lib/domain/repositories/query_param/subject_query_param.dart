import 'package:course/app/models/base_query_params.dart';
import 'package:json_annotation/json_annotation.dart';
part 'subject_query_param.g.dart';

/// Query params cho Subject API
@JsonSerializable(createFactory: false)
class SubjectQueryParams extends BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final String? name;

  @JsonKey(includeIfNull: false)
  final bool? status;

  const SubjectQueryParams({
    this.name,
    this.status,
    super.page,
    super.entry,
    super.field,
    super.sort,
  });

  @override
  Map<String, dynamic> toJson() => _$SubjectQueryParamsToJson(this);

  @override
  SubjectQueryParams copyWith({
    String? name,
    bool? status,
    int? page,
    int? entry,
    String? field,
    SortOrder? sort,
  }) {
    return SubjectQueryParams(
      name: name ?? this.name,
      status: status ?? this.status,
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}
