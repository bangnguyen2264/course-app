import 'package:course/app/models/base_query_params.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam_result_query_param.g.dart';

@JsonSerializable(createFactory: false)
class ExamResultQueryParam extends BaseQueryParams {
  @JsonKey(includeIfNull: false)
  final int? examId;
  @JsonKey(includeIfNull: false)
  final int? userId;
  ExamResultQueryParam({
    this.examId,
    this.userId,
    super.page,
    super.entry,
    super.field,
    super.sort,
  });

  Map<String, dynamic> toJson() => _$ExamResultQueryParamToJson(this);
}
