import 'dart:convert';

/// Serializes (json.encode) all fields in a Map recursively
/// for compatibility with the current backend,
/// i.e., maps within the object are also converted to their
/// respective JSON representation.
String serializeJsonRecursively(dynamic source) {
  if (source is Map<String, dynamic>) {
    return json.encode(
      source.map(
        (String key, dynamic value) => MapEntry<String, dynamic>(
              key,
              serializeJsonRecursively(value),
            ),
      ),
    );
  }
  if (source is List) {
    return json.encode(source
        .map((dynamic value) => serializeJsonRecursively(value))
        .toList());
  }

  return source.toString();
}

/// Deserializes (json.decode) all fields in a Map recursively
/// for compatibility with the current backend,
/// i.e., maps within the object are also converted to their
/// respective Map representation.
dynamic deserializeJsonRecursively(String source) {
  dynamic deserialized;
  try {
    deserialized = json.decode(source);
  } on FormatException {
    return source;
  }

  if (deserialized is Map<String, dynamic>) {
    return deserialized.map(
      (String key, dynamic value) => MapEntry<String, dynamic>(
            key,
            value is String ? deserializeJsonRecursively(value) : value,
          ),
    );
  }
  if (deserialized is List) {
    return deserialized
        .map((dynamic element) => deserializeJsonRecursively(element))
        .toList();
  }

  return deserialized;
}
