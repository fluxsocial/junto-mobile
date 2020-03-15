import 'package:shared_preferences/shared_preferences.dart';

class AppRepo {
  AppRepo() {
    _loadLayout();
  }

  bool _twoColumn = false;

// Loads the previously save configuration. If there is none, it starts with a
// default of false.
  Future<void> _loadLayout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool _result = prefs.getBool('twoColumnView');
    if (_result != null) {
      _twoColumn = _result;
    } else {
      prefs.setBool('twoColumnView', _twoColumn);
    }
    return;
  }

// Exposes the current layout config.
  bool get twoColumnLayout => _twoColumn;

  // Allows the layout type to be updated and saved.
  Future<void> setLayout(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('twoColumnView', value);
    _twoColumn = value;
    return;
  }
}
