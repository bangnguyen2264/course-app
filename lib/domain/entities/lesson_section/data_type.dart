import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum DataType {
  @JsonValue('TEXT')
  text('TEXT'),
  @JsonValue('IMAGE')
  image('IMAGE'),
  @JsonValue('VIDEO')
  video('VIDEO'),
  @JsonValue('AUDIO')
  audio('AUDIO'),
  @JsonValue('OTHER')
  other('OTHER');

  final String value;
  const DataType(this.value);

  static DataType fromString(String? value) {
    if (value == null) return DataType.other;
    return DataType.values.firstWhere(
      (e) => e.value.toUpperCase() == value.toUpperCase(),
      orElse: () => DataType.other,
    );
  }
}
