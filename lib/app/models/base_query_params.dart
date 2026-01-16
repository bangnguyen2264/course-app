import 'package:json_annotation/json_annotation.dart';

part 'base_query_params.g.dart';

/// Enum cho thứ tự sắp xếp
enum SortOrder {
  @JsonValue('ASC')
  ASC,
  @JsonValue('DESC')
  DESC;

  String get value => name;
}

/// Base class chứa các param phân trang và sắp xếp chung
@JsonSerializable(createFactory: false)
class BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final int? page;

  @JsonKey(includeIfNull: false)
  final int? entry;

  final String field;

  final String sort;

  const BaseQueryParams({this.page = 0, this.entry = 10, this.field = 'id', String? sort})
    : sort = sort ?? 'ASC';

  const BaseQueryParams.withSortOrder({
    this.page = 0,
    this.entry = 10,
    this.field = 'id',
    SortOrder sortOrder = SortOrder.ASC,
  }) : sort = sortOrder == SortOrder.ASC ? 'ASC' : 'DESC';

  Map<String, dynamic> toJson() => _$BaseQueryParamsToJson(this);

  /// Copy with new values
  BaseQueryParams copyWith({int? page, int? entry, String? field, String? sort}) {
    return BaseQueryParams(
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}

