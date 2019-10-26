import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:junto_beta_mobile/app/app.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final Backend backend = await Backend.init();
  runLoggedApp(JuntoApp(backend: backend));
}
