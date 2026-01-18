import 'package:json_annotation/json_annotation.dart';

part 'base_query_params.g.dart';

/// Enum cho thứ tự sắp xếp
enum SortOrder {
  @JsonValue('ASC')
  asc('ASC'),
  @JsonValue('DESC')
  desc('DESC');

  final String value;
  const SortOrder(this.value);

  /// Parse từ string
  static SortOrder fromString(String? value) {
    if (value == null) return SortOrder.asc;
    switch (value.toUpperCase()) {
      case 'DESC':
        return SortOrder.desc;
      case 'ASC':
      default:
        return SortOrder.asc;
    }
  }
}

/// Base class chứa các param phân trang và sắp xếp chung
@JsonSerializable(createFactory: false)
class BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final int? page;

  @JsonKey(includeIfNull: false)
  final int? entry;

  final String field;

  @JsonKey(toJson: sortOrderToJson)
  final SortOrder sort;

  const BaseQueryParams({
    this.page = 0,
    this.entry = 10,
    this.field = 'id',
    this.sort = SortOrder.asc,
  });

  /// Convert SortOrder to JSON string
  static String sortOrderToJson(SortOrder sort) => sort.value;

  Map<String, dynamic> toJson() => _$BaseQueryParamsToJson(this);

  /// Copy with new values
  BaseQueryParams copyWith({int? page, int? entry, String? field, SortOrder? sort}) {
    return BaseQueryParams(
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}
