import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';

class OnBoardingRepo {
  OnBoardingRepo(UserDataProvider repo) {
    _repo = repo;
    loadTutorialState();
  }
  bool _showLotusTutorial = false;
  bool _showPerspectiveTutorial = false;
  bool _showCollectiveTutorial = false;
  bool _showPackTutorial = false;
  bool _showDenTutorial = false;
  bool _showCreateTutorial = false;
  bool _showRelationTutorial = false;
  bool _showGroupTutorial = false;
  Box _appBox;
  UserDataProvider _repo;

  bool get showLotusTutorial => _showLotusTutorial;
  bool get showPerspectiveTutorial => _showPerspectiveTutorial;
  bool get showCollectiveTutorial => _showCollectiveTutorial;
  bool get showPackTutorial => _showPackTutorial;
  bool get showDenTutorial => _showDenTutorial;
  bool get showCreateTutorial => _showCreateTutorial;
  bool get showRelationTutorial => _showRelationTutorial;
  bool get showGroupTutorial => _showGroupTutorial;

  Future<void> loadTutorialState() async {
    final time = DateTime.now();
    final timeDifference =
        _repo.userProfile?.pack?.createdAt?.difference(time)?.inMinutes;
    if (_repo.userProfile != null && timeDifference < 1) {
      _appBox = await Hive.box(HiveBoxes.kAppBox);
      _showLotusTutorial =
          await _appBox.get(HiveKeys.kShowLotusTutorial) ?? true;
      _showCollectiveTutorial =
          await _appBox.get(HiveKeys.kShowCollectiveTutorial) ?? true;
      _showPackTutorial = await _appBox.get(HiveKeys.kShowPackTutorial) ?? true;
      _showDenTutorial = await _appBox.get(HiveKeys.kShowDenTutorial) ?? true;
      _showPerspectiveTutorial =
          await _appBox.get(HiveKeys.kShowPerspectiveTutorial) ?? true;
      _showCreateTutorial =
          await _appBox.get(HiveKeys.kShowCreateTutorial) ?? true;
      _showRelationTutorial =
          await _appBox.get(HiveKeys.kRelationsTutorial) ?? true;
      _showGroupTutorial = await _appBox.get(HiveKeys.kGroupTutorial) ?? true;
    }
  }

  Future<void> setViewed(String key, bool value) async {
    switch (key) {
      case HiveKeys.kShowLotusTutorial:
        _showLotusTutorial = false;
        await _appBox.put(HiveKeys.kShowLotusTutorial, value);
        return;
      case HiveKeys.kShowCollectiveTutorial:
        _showCollectiveTutorial = false;
        await _appBox.put(HiveKeys.kShowCollectiveTutorial, value);
        return;
      case HiveKeys.kShowPackTutorial:
        _showPackTutorial = false;
        await _appBox.put(HiveKeys.kShowPackTutorial, value);
        return;
      case HiveKeys.kShowDenTutorial:
        _showDenTutorial = false;
        await _appBox.put(HiveKeys.kShowDenTutorial, value);
        return;
      case HiveKeys.kShowPerspectiveTutorial:
        _showPerspectiveTutorial = false;
        await _appBox.put(HiveKeys.kShowPerspectiveTutorial, value);
        return;
      case HiveKeys.kShowCreateTutorial:
        _showCreateTutorial = false;
        await _appBox.put(HiveKeys.kShowCreateTutorial, value);
        return;
      case HiveKeys.kRelationsTutorial:
        _showRelationTutorial = false;
        await _appBox.put(HiveKeys.kRelationsTutorial, value);
        return;
      case HiveKeys.kGroupTutorial:
        _showGroupTutorial = false;
        await _appBox.put(HiveKeys.kGroupTutorial, value);
        return;
    }
  }
}
