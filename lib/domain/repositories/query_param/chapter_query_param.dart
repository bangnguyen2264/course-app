import 'package:course/app/models/base_query_params.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chapter_query_param.g.dart';

/// Query params cho Chapter API
@JsonSerializable(createFactory: false)
class ChapterQueryParams extends BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final String? search;

  @JsonKey(includeIfNull: false)
  final int? subjectId;

  const ChapterQueryParams({
    this.search,
    this.subjectId,
    super.page,
    super.entry,
    super.field,
    super.sort,
  });

  @override
  Map<String, dynamic> toJson() => _$ChapterQueryParamsToJson(this);

  @override
  ChapterQueryParams copyWith({
    String? search,
    int? subjectId,
    int? page,
    int? entry,
    String? field,
    SortOrder? sort,
  }) {
    return ChapterQueryParams(
      search: search ?? this.search,
      subjectId: subjectId ?? this.subjectId,
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}
