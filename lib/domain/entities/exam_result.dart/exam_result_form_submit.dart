import 'package:json_annotation/json_annotation.dart';

part 'exam_result_form_submit.g.dart';

@JsonSerializable(createFactory: false)
class ExamResultFormSubmit {
  final int examId;
  final int userId;
  final int timeTaken;
  final Map<String, dynamic> answers;

  ExamResultFormSubmit({
    required this.examId,
    required this.userId,
    required this.timeTaken,
    required this.answers,
  });

  Map<String, dynamic> toJson() => _$ExamResultFormSubmitToJson(this);
}