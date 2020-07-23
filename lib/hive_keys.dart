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
  static const kShowLotusTutorial = "show-lotus-tutorial";
  static const kShowCollectiveTutorial = "show-collective-tutorial";
  static const kShowPackTutorial = "show-pack-tutorial";
  static const kShowDenTutorial = "show-den-tutorial";
  static const kShowPerspectiveTutorial = "show-perspective-tutorial";
  static const kShowCreateTutorial = "show-create-tutorial";
  static const kRelationsTutorial = "show-relation-tutorial";
  static const kGroupTutorial = "show-group-tutorial";
}

/// Class containing the name of the different "boxes" used by the application.
class HiveBoxes {
  /// Used to access the application box.
  static const kAppBox = 'app';
  static const kNotifications = 'notifications';
  static const kExpressions = 'expressions';
  static const kPack = 'pack';
  static const kDenRoot = 'den root';
  static const kDenSub = 'den sub';
  static const kPerspectives = 'perspectives';

  static List<String> get keys => [
        kAppBox,
        kNotifications,
        kExpressions,
        kDenRoot,
        kDenSub,
      ];
}
