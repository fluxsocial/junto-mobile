import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class JuntoApp extends StatelessWidget {
  const JuntoApp({
    Key key,
    @required this.backend,
  }) : super(key: key);

  final Backend backend;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserDataProvider>(
          create: (ctx) => backend.dataProvider,
          lazy: false,
        ),
        ChangeNotifierProvider<JuntoThemesProvider>.value(
            value: backend.themesProvider),
        Provider<SearchService>.value(value: backend.searchRepo),
        Provider<AuthRepo>.value(value: backend.authRepo),
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
        child: MaterialAppWithTheme(),
      ),
    );
  }
}
