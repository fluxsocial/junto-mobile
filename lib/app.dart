import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/user_provider.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/loading_screen/junto_loading_screen.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/themes.dart';
import 'package:provider/provider.dart';

import 'providers/provider.dart';

class JuntoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoAppState();
  }
}

class JuntoAppState extends State<JuntoApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        Provider<SearchProvider>(
          builder: (BuildContext context) => SearchProvider(),
        ),
        Provider<AuthenticationProvider>(
          builder: (BuildContext context) => AuthenticationCentralized(),
        ),
        Provider<UserProvider>(
          builder: (BuildContext context) => UserProviderCentralized(),
        ),
        Provider<CollectiveProvider>(
          builder: (BuildContext context) => CollectiveProviderCentralized(),
        ),
        Provider<SpheresProvider>(
          builder: (BuildContext context) => SphereProviderCentralized(),
        ),
      ],
      child: MaterialApp(
        theme: JuntoThemes().juntoLightTheme,
        home: JuntoLoading(),
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
