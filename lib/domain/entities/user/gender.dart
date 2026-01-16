import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum Gender {
  @JsonValue('MALE')
  male('MALE'),
  @JsonValue('FEMALE')
  female('FEMALE');

  final String value;
  const Gender(this.value);

  static Gender fromString(String? value) {
    if (value == null) return Gender.male;
    return Gender.values.firstWhere(
      (e) => e.value.toUpperCase() == value.toUpperCase(),
      orElse: () => Gender.male,
    );
  }
}
