import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Mixin containing a helper list method
mixin ListDistinct {
  /// Creates a new list with the unique elements form [listOne] and [listTwo].
  /// The new list is returned  with the specified type [T]
  List<T> distinct<T>(List<T> listOne, List<T> listTwo) {
    final List<T> _newList = <T>[];
    _newList.addAll(listOne);
    for (final T item in listTwo) {
      if (_newList.contains(item)) {
        _newList.remove(item);
      }
      _newList.add(item);
    }
    return _newList;
  }
}

mixin RFC3339 {
  static DateTime parseRfc3339(String time) {
    if (time != null) {
      if (time.length > 25) {
        final String limitedString =
            time.substring(0, 20) + time[time.length - 1];
        return DateTime.parse(limitedString);
      } else {
        return DateTime.parse(time);
      }
    }
    return null;
  }
}

/// Mixin which allows you to verify whether the [incoming] user is
/// the same as the user currently logged into the application.
mixin MemberValidation {
  Future<bool> isHostUser(UserProfile incoming) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String _userAddress = _prefs.getString('user_id');
    return incoming.address == _userAddress;
  }

  /// Navigates the user to the correct profile "Den" screen based on whether
  /// they are the host (logged in) user or not.
  Future<void> showUserDen(BuildContext context, UserProfile profile) async {
    if (await isHostUser(profile)) {
      Navigator.push(
        context,
        CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) => JuntoDen(),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => JuntoMember(profile: profile),
      ),
    );
    return;
  }
}

mixin DateParser {
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
