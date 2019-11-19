import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:provider/provider.dart';

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
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<JuntoThemesProvider>(
          builder: (_) => JuntoThemesProvider(JuntoThemes().juntoLightIndigo),
        ),
        Provider<SearchProvider>.value(value: backend.searchProvider),
        Provider<AuthRepo>.value(value: backend.authRepo),
        Provider<UserRepo>.value(value: backend.userRepo),
        Provider<CollectiveService>.value(value: backend.collectiveProvider),
        Provider<GroupRepo>.value(value: backend.groupsProvider),
        Provider<ExpressionRepo>.value(value: backend.expressionRepo),
      ],
      child: MaterialAppWithTheme(
        loggedIn: widget.loggedIn,
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
    final JuntoThemesProvider theme = Provider.of<JuntoThemesProvider>(context);
    return MaterialApp(
      home: loggedIn ? JuntoTemplate() : Welcome(),
      title: 'JUNTO Alpha',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
    );
  }
}
