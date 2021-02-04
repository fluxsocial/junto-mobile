import 'package:flutter/material.dart';
import 'package:flutter_liquidcore/liquidcore.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/app/material_app_with_theme.dart';
import 'package:junto_beta_mobile/app/providers/bloc_providers.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/onboarding_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

class JuntoApp extends StatelessWidget {
  JuntoApp({
    Key key,
    @required this.backend,
  }) : super(key: key);

  final Backend backend;
  MicroService _microService;

  void initMicroService() async {
    String uri;

    try {
      uri = "@flutter_assets/acai/main.js";

      final _microService = MicroService(uri);

      // Start the service.
      await _microService.start();

      final id = await _microService.getMicroServiceId();

      print('test: 1 ${id} | ${_microService.isStarted}');

      if (_microService.isStarted) {
        print('test: Microservice started');
        await _microService.emit('init');
        try {
          final result = await http.get('http://10.0.2.2:4000');
          print('test: ${result.body.replaceAll('\n', '')}');
        } catch (e) {
          print('test: 1 $e');
        }
      }

      print('test: 1 ${id} | ${_microService.hasExit}');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_microService == null) {
      initMicroService();
    }
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserDataProvider>.value(
          value: backend.dataProvider,
        ),
        ChangeNotifierProvider<JuntoThemesProvider>.value(
            value: backend.themesProvider),
        Provider<SearchService>.value(value: backend.searchRepo),
        ChangeNotifierProvider<AuthRepo>.value(value: backend.authRepo),
        Provider<UserRepo>.value(value: backend.userRepo),
        Provider<CollectiveService>.value(value: backend.collectiveProvider),
        Provider<GroupRepo>.value(value: backend.groupsProvider),
        Provider<ExpressionRepo>.value(value: backend.expressionRepo),
        Provider<SearchRepo>.value(value: backend.searchRepo),
        Provider<NotificationRepo>.value(value: backend.notificationRepo),
        Provider<LocalCache>.value(value: backend.db),
        Provider<OnBoardingRepo>.value(value: backend.onBoardingRepo),
        ChangeNotifierProvider<AppRepo>.value(value: backend.appRepo),
        ChangeNotifierProvider(
          create: (_) => NotificationsHandler(backend.notificationRepo),
          lazy: false,
        ),
      ],
      child: BlocProviders(
        backend: backend,
        child: Portal(
          child: MaterialAppWithTheme(),
        ),
      ),
    );
  }
}
