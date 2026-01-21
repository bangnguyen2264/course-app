import 'package:course/app/models/base_query_params.dart';
import 'package:course/domain/entities/exam/exam_duration.dart';
import 'package:json_annotation/json_annotation.dart';
part 'exam_query_param.g.dart';

/// Query params cho Exam API
@JsonSerializable(createFactory: false)
class ExamQueryParam extends BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final String? search;
  @JsonKey(includeIfNull: false)
  final int? subjectId;
  @JsonKey(includeIfNull: false)
  final ExamDuration? duration;

  ExamQueryParam({
    this.search,
    this.subjectId,
    this.duration,
    super.page,
    super.entry,
    super.field,
    super.sort,
  });

  @override
  Map<String, dynamic> toJson() => _$ExamQueryParamToJson(this);
  @override
  ExamQueryParam copyWith({
    String? search,
    int? subjectId,
    ExamDuration? duration,
    int? page,
    int? entry,
    String? field,
    SortOrder? sort,
  }) {
    return ExamQueryParam(
      search: search ?? this.search,
      subjectId: subjectId ?? this.subjectId,
      duration: duration ?? this.duration,
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}
