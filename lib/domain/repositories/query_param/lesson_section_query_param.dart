import 'package:course/app/models/base_query_params.dart';
import 'package:course/domain/entities/lesson_section/data_type.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lesson_section_query_param.g.dart';

/// Query params cho LessonSection API
@JsonSerializable(createFactory: false)
class LessonSectionQueryParams extends BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final String? search;

  @JsonKey(includeIfNull: false)
  final int? lessonId;

  @JsonKey(includeIfNull: false)
  final DataType? dataType;

  const LessonSectionQueryParams({
    this.search,
    this.lessonId,
    this.dataType,
    super.page,
    super.entry,
    super.field,
    super.sort,
  });

  @override
  Map<String, dynamic> toJson() => _$LessonSectionQueryParamsToJson(this);

  @override
  LessonSectionQueryParams copyWith({
    String? search,
    int? lessonId,
    DataType? dataType,
    int? page,
    int? entry,
    String? field,
    SortOrder? sort,
  }) {
    return LessonSectionQueryParams(
      search: search ?? this.search,
      lessonId: lessonId ?? this.lessonId,
      dataType: dataType ?? this.dataType,
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}
