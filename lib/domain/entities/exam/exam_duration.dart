import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ExamDuration {
  @JsonValue('MIN_10')
  m10('MIN_10'),
  @JsonValue('MIN_15')
  m15('MIN_15'),
  @JsonValue('MIN_30')
  m30('MIN_30'),
  @JsonValue('MIN_45')
  m45('MIN_45'),
  @JsonValue('MIN_60')
  m60('MIN_60'),
  @JsonValue('MIN_90')
  m90('MIN_90'),
  @JsonValue('MIN_120')
  m120('MIN_120');
  final String value;
  const ExamDuration(this.value);
}