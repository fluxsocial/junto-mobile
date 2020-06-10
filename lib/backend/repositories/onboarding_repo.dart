import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';

class OnBoardingRepo {
  OnBoardingRepo(UserDataProvider repo) {
    _repo = repo;
    _loadTutorialState();
  }
  bool _showLotusTutorial = false;
  bool _showPerspectiveTutorial = false;
  bool _showCollectiveTutorial = false;
  bool _showPackTutorial = false;
  bool _showDenTutorial = false;
  bool _showCreateTutorial = false;
  Box _appBox;
  UserDataProvider _repo;

  bool get showLotusTutorial => _showLotusTutorial;
  bool get showPerspectiveTutorial => _showPerspectiveTutorial;
  bool get showCollectiveTutorial => _showCollectiveTutorial;
  bool get showPackTutorial => _showPackTutorial;
  bool get showDenTutorial => _showDenTutorial;
  bool get showCreateTutorial => _showCreateTutorial;

  Future<void> _loadTutorialState() async {
    final time = DateTime.now();
    if (_repo.userProfile != null &&
        _repo.userProfile.pack.createdAt.difference(time).inMinutes < 2) {
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
    }
  }
}
