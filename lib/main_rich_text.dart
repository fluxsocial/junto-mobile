import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome, SystemUiOverlayStyle;
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/logging.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_editor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  final Backend backend = await Backend.init();
  final bool _loggedIn = await backend.authRepo.isLoggedIn();
  runLoggedApp(
    MaterialApp(
      theme: JuntoThemes().juntoLightIndigo.copyWith(
            canvasColor: Colors.white,
          ),
      debugShowCheckedModeBanner: false,
      title: 'JUNTO Alpha',
      home: RichTextEditorExample(),
    ),
  );
}
