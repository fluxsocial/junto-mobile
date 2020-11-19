import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:junto_beta_mobile/app/app.dart';
import 'package:junto_beta_mobile/app/logger/sentry.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/bloc_delegate.dart';

Future<void> mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  Bloc.observer = SimpleBlocObserver();
  final Backend backend = await Backend.init();

  //TODO(Nash+Eric): Decide on how we want to handle notifications that are received in app
  FirebaseMessaging()
    ..configure(
      onLaunch: (val) async => print('onLaunch $val'),
      onMessage: (val) async => print('onMessage $val'),
    );

  runLoggedApp(JuntoApp(backend: backend));
}
