import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:junto_beta_mobile/app/app.dart';
import 'package:junto_beta_mobile/app/logger/sentry.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/device_preview.dart';

Future<void> mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final Backend backend = await Backend.init();
  final bool _loggedIn = await backend.authRepo.isLoggedIn();
  runLoggedApp(
    DevicePreviewWrapper(
      child: JuntoApp(
        backend: backend,
        loggedIn: _loggedIn ?? false,
      ),
    ),
  );
}
