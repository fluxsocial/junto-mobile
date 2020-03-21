import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class JuntoApp extends StatefulWidget {
  const JuntoApp({
    Key key,
    @required this.backend,
    @required this.loggedIn,
  }) : super(key: key);

  final Backend backend;
  final bool loggedIn;

  @override
  State<StatefulWidget> createState() {
    return JuntoAppState();
  }
}

class JuntoAppState extends State<JuntoApp> {
  Backend get backend => widget.backend;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<JuntoThemesProvider>(
          create: (BuildContext context) =>
              JuntoThemesProvider(backend.currentTheme),
        ),
        Provider<SearchService>.value(value: backend.searchRepo),
        Provider<AuthRepo>.value(value: backend.authRepo),
        Provider<UserRepo>.value(value: backend.userRepo),
        Provider<CollectiveService>.value(value: backend.collectiveProvider),
        Provider<GroupRepo>.value(value: backend.groupsProvider),
        Provider<ExpressionRepo>.value(value: backend.expressionRepo),
        Provider<SearchRepo>.value(value: backend.searchRepo),
        Provider<NotificationRepo>.value(value: backend.notificationRepo),
        Provider<AppRepo>.value(value: backend.appRepo),
      ],
      child: ChangeNotifierProvider<UserDataProvider>(
        create: (ctx) => UserDataProvider(
          ctx.repository<UserRepo>(),
          ctx.repository<AppRepo>(),
        ),
        lazy: false,
        child: MaterialAppWithTheme(
          loggedIn: widget.loggedIn,
        ),
      ),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    Key key,
    @required this.loggedIn,
  }) : super(key: key);

  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (BuildContext context, JuntoThemesProvider theme, _) {
        if (theme.currentTheme != null) {
          theme.currentTheme.brightness == Brightness.dark
              ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
              : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        }
        return MaterialApp(
          home: loggedIn
              ? const JuntoLotus(
                  address: null,
                  expressionContext: ExpressionContext.Collective,
                )
              : Welcome(),
          title: 'JUNTO Alpha',
          debugShowCheckedModeBanner: false,
          theme: theme.getTheme(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
