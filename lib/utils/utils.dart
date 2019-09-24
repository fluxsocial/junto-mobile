import 'dart:convert';

/// Should not be used. Values that are expected
/// to be `String`s are actually non-nullable.
Map<String, dynamic> _stringifyValuesRecursively(Map<String, dynamic> source) {
  return source.map(
    (String key, dynamic value) {
      return MapEntry<String, dynamic>(
        key,
        value is Map ? _stringifyValuesRecursively(value) : value.toString(),
      );
    },
  );
}

/// Serializes (json.encode) all fields in `source`
/// for compatibility with the current backend,
/// i.e., maps within objects are also converted to their
/// respective JSON representation.
String serializeHoloJson(Map<String, dynamic> source) {
  final Map<String, dynamic> stringifiedValuesMap =
      _stringifyValuesRecursively(source);

  return json.encode(
    stringifiedValuesMap.map(
      (String key, dynamic value) {
        return MapEntry<String, dynamic>(
          key,
          value is Map ? json.encode(value) : value,
        );
      },
    ),
  ).replaceAll('\\\\', '');
}

/// Deserializes (json.decode) all fields `source`
/// for compatibility with the current backend,
/// i.e., maps within the `source` are also converted to their
/// respective JSON representation.
dynamic deserializeHoloJson(String source) {
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
            value is String ? deserializeHoloJson(value) : value,
          ),
    );
  }
  if (deserialized is List) {
    return deserialized
        .map((dynamic element) => deserializeHoloJson(element))
        .toList();
  }

  return deserialized;
}

mixin AddUserToList {
  List<String> placeUser(String data, List<String> list) {
    if (list.contains(data)) {
      final List<String> newList = list;
      newList.remove(data);
      return newList;
    } else {
      final List<String> newList = list;
      newList.add(data);
      return newList;
    }
  }
}