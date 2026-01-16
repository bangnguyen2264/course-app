/// Utility functions for safely parsing JSON values
/// Prevents "is not a subtype" and null pointer errors
library;

// ===================== INT PARSING =====================

/// Parse any value to int safely
/// Returns [defaultValue] if parsing fails (default: 0)
int parseInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  if (value is bool) return value ? 1 : 0;
  return defaultValue;
}

/// Parse any value to nullable int
int? parseIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

// ===================== DOUBLE PARSING =====================

/// Parse any value to double safely
/// Returns [defaultValue] if parsing fails (default: 0.0)
double parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

/// Parse any value to nullable double
double? parseDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

// ===================== STRING PARSING =====================

/// Parse any value to string safely
/// Returns [defaultValue] if null (default: '')
String parseString(dynamic value, [String defaultValue = '']) {
  if (value == null) return defaultValue;
  return value.toString();
}

/// Parse any value to nullable string
String? parseStringOrNull(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

// ===================== BOOL PARSING =====================

/// Parse any value to bool safely
/// Returns [defaultValue] if parsing fails (default: false)
/// Accepts: true/false, 1/0, "true"/"false", "1"/"0", "yes"/"no"
bool parseBool(dynamic value, [bool defaultValue = false]) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
  }
  return defaultValue;
}

/// Parse any value to nullable bool
bool? parseBoolOrNull(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
  }
  return null;
}

// ===================== DATETIME PARSING =====================

/// Parse any value to DateTime safely
/// Supports: ISO 8601 string, milliseconds since epoch
/// Returns [defaultValue] if parsing fails
DateTime parseDateTime(dynamic value, [DateTime? defaultValue]) {
  final result = parseDateTimeOrNull(value);
  return result ?? defaultValue ?? DateTime.fromMillisecondsSinceEpoch(0);
}

/// Parse any value to nullable DateTime
DateTime? parseDateTimeOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) {
    // Try ISO 8601 format
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
    // Try milliseconds as string
    final millis = int.tryParse(value);
    if (millis != null) return DateTime.fromMillisecondsSinceEpoch(millis);
  }
  return null;
}

// ===================== LIST PARSING =====================

/// Parse any value to List<T> safely
/// [fromJson] is the converter function for each item
List<T> parseList<T>(dynamic value, T Function(dynamic json) fromJson) {
  if (value == null) return <T>[];
  if (value is! List) return <T>[];
  return value
      .map((e) {
        try {
          return fromJson(e);
        } catch (_) {
          return null;
        }
      })
      .whereType<T>()
      .toList();
}

/// Parse list of primitives (int, String, etc.)
List<T> parsePrimitiveList<T>(dynamic value) {
  if (value == null) return <T>[];
  if (value is! List) return <T>[];
  return value.whereType<T>().toList();
}

/// Parse list of int
List<int> parseIntList(dynamic value) {
  if (value == null) return <int>[];
  if (value is! List) return <int>[];
  return value.map((e) => parseInt(e)).toList();
}

/// Parse list of String
List<String> parseStringList(dynamic value) {
  if (value == null) return <String>[];
  if (value is! List) return <String>[];
  return value.map((e) => parseString(e)).toList();
}

// ===================== MAP PARSING =====================

/// Parse any value to Map<String, dynamic> safely
Map<String, dynamic> parseMap(dynamic value) {
  if (value == null) return <String, dynamic>{};
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Parse any value to nullable Map<String, dynamic>
Map<String, dynamic>? parseMapOrNull(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}

// ===================== ENUM PARSING =====================

/// Parse string to enum safely
/// Returns [defaultValue] if not found
T parseEnum<T extends Enum>(dynamic value, List<T> values, T defaultValue) {
  if (value == null) return defaultValue;
  final stringValue = value.toString().toUpperCase();
  return values.firstWhere((e) => e.name.toUpperCase() == stringValue, orElse: () => defaultValue);
}

/// Parse string to nullable enum
T? parseEnumOrNull<T extends Enum>(dynamic value, List<T> values) {
  if (value == null) return null;
  final stringValue = value.toString().toUpperCase();
  try {
    return values.firstWhere((e) => e.name.toUpperCase() == stringValue);
  } catch (_) {
    return null;
  }
}

// ===================== OBJECT PARSING =====================

/// Parse nested object safely
T? parseObject<T>(dynamic value, T Function(Map<String, dynamic> json) fromJson) {
  if (value == null) return null;
  if (value is! Map) return null;
  try {
    return fromJson(parseMap(value));
  } catch (_) {
    return null;
  }
}

/// Parse nested object with default value
T parseObjectOrDefault<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) fromJson,
  T defaultValue,
) {
  return parseObject(value, fromJson) ?? defaultValue;
}
