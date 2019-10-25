import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/loading_screen/junto_loading_screen.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:provider/provider.dart';

class JuntoApp extends StatefulWidget {
  const JuntoApp({
    Key key,
    @required this.backend,
  }) : super(key: key);

  final Backend backend;

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
      providers: <SingleChildCloneableWidget>[
        Provider<SearchProvider>.value(value: backend.searchProvider),
        Provider<AuthRepo>.value(value: backend.authRepo),
        Provider<UserService>.value(value: backend.userProvider),
        Provider<CollectiveProvider>.value(value: backend.collectiveProvider),
        Provider<SpheresProvider>.value(value: backend.spheresProvider),
        Provider<ExpressionRepo>.value(value: backend.expressionRepo),
      ],
      child: MaterialApp(
        theme: JuntoThemes().juntoLightTheme,
        home:  JuntoLoading(),
        debugShowCheckedModeBanner: false,
        title: 'Junto Alpha',
        color: JuntoPalette.juntoPrimary,
        routes: <String, WidgetBuilder>{
          '/welcome': (BuildContext context) => Welcome(),
          '/template': (BuildContext context) => JuntoTemplate(),
          '/create': (BuildContext context) => const JuntoCreate('collective'),
        },
      ),
    );
  }
}
