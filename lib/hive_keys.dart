/// Various item keys used to store data in Hive boxes
class HiveKeys {
  /// Used to access
  static const kisLoggedIn = 'isLoggedIn';
  static const kUserFollowPerspectiveId = 'userFollowPerspectiveId';
  static const kUserId = 'userId';
  static const kUserData = 'user_data';
  static const kLayoutView = 'twoColumnView';
  static const kAuth = 'auth';
  static const kTheme = 'current-theme';
  static const kNightMode = 'night-mode';
  static const kLastNotification = 'last_notification';
}

/// Class containing the name of the different "boxes" used by the application.
class HiveBoxes {
  /// Used to access the application box.
  static const kAppBox = 'app';
  static const kNotifications = 'notifications';
  static const kExpressions = 'expressions';
  static const kPack = 'pack';
  static const kDen = 'pack';

  static List<String> get keys => [kAppBox, kNotifications, kExpressions, kDen];
}
