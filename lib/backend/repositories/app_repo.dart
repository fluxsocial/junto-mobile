import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/hive_keys.dart';

class AppRepo {
  AppRepo() {
    _loadLayout();
  }

  bool _twoColumn = false;

// Loads the previously save configuration. If there is none, it starts with a
// default of false.
  Future<void> _loadLayout() async {
    final box = await Hive.openLazyBox(HiveBoxes.kAppBox, encryptionKey: key);
    final bool _result = await box.get(HiveKeys.kLayoutView);
    if (_result != null) {
      _twoColumn = _result;
    } else {
      box.put(HiveKeys.kLayoutView, _twoColumn);
    }
    return;
  }

  // Exposes the current layout config.
  bool get twoColumnLayout => _twoColumn;

  // Allows the layout type to be updated and saved.
  Future<void> setLayout(bool value) async {
    final box = await Hive.openLazyBox(HiveBoxes.kAppBox, encryptionKey: key);
    box.delete(HiveKeys.kLayoutView);
    box.put(HiveKeys.kLayoutView, value);
    _twoColumn = value;
    return;
  }
}
