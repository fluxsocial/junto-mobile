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

mixin AddUserToList<T> {
  List<T> placeUser(T data, List<T> list) {
    if (list.contains(data)) {
      final List<T> newList = list;
      newList.remove(data);
      return newList;
    } else {
      final List<T> newList = list;
      newList.add(data);
      return newList;
    }
  }
}

mixin DateParser{

  String transformMinute(int minute) {
    if (minute < 10) {
      return '0' + minute.toString();
    } else {
      return minute.toString();
    }
  }

  String transformMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
    }
    return '';
  }

  int transformMonthToInt(String month) {
    switch (month) {
      case 'Jan':
        return 1;
        break;
      case 'Feb':
        return 2;
        break;
      case 'Mar':
        return 3;
        break;
      case 'Apr':
        return 4;
        break;
      case 'May':
        return 5;
        break;
      case 'Jun':
        return 6;
        break;
      case 'Jul':
        return 7;
        break;
      case 'Aug':
        return 8;
        break;
      case 'Sep':
        return 9;
        break;
      case 'Oct':
        return 10;
        break;
      case 'Nov':
        return 11;
        break;
      case 'Dec':
        return 12;
        break;
    }
    return 0;
  }
}
