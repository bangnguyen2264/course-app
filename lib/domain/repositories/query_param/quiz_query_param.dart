import 'package:course/app/models/base_query_params.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quiz_query_param.g.dart';

@JsonSerializable(createFactory: false)
class QuizQueryParam extends BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final String? search;
  @JsonKey(includeIfNull: false)
  final int? subjectId;
  @JsonKey(includeIfNull: false)
  final bool? multipleChoice;
  @JsonKey(includeIfNull: false)
  final int? examId;

  QuizQueryParam({
    this.search,
    this.subjectId,
    this.multipleChoice,
    this.examId,
    super.page,
    super.entry,
    super.field,
    super.sort,
  });

  @override
  Map<String, dynamic> toJson() => _$QuizQueryParamToJson(this);

  @override
  QuizQueryParam copyWith({
    String? search,
    int? subjectId,
    bool? multipleChoice,
    int? examId,
    int? page,
    int? entry,
    String? field,
    SortOrder? sort,
  }) {
    return QuizQueryParam(
      search: search ?? this.search,
      subjectId: subjectId ?? this.subjectId,
      multipleChoice: multipleChoice ?? this.multipleChoice,
      examId: examId ?? this.examId,
      page: page ?? this.page,
      entry: entry ?? this.entry,
      field: field ?? this.field,
      sort: sort ?? this.sort,
    );
  }
}
