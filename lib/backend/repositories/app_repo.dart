import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/hive_keys.dart';

/// Repository retrieving and saving various app settings:
///
/// - column layout of expressions
class AppRepo {
  Box _appBox;

  bool _twoColumn = false;

  /// Exposes the current layout config.
  bool get twoColumnLayout => _twoColumn;

  AppRepo() {
    _loadLayout();
  }

  /// Loads the previously save configuration. If there is none, it starts with a
  /// default of false.
  Future<void> _loadLayout() async {
    _appBox = await Hive.box(HiveBoxes.kAppBox);
    final bool _result = _appBox.get(HiveKeys.kLayoutView);
    if (_result != null) {
      _twoColumn = _result;
    } else {
      await _appBox.put(HiveKeys.kLayoutView, _twoColumn);
    }
    return;
  }

  /// Allows the layout type to be updated and saved.
  Future<void> setLayout(bool value) async {
    await _appBox.put(HiveKeys.kLayoutView, value);
    _twoColumn = value;
    return;
  }
}
