import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/providers/auth_provider/auth_provider.dart';
import 'package:junto_beta_mobile/providers/packs_provider/packs_provider.dart';
import 'package:junto_beta_mobile/providers/search_provider/search_provider.dart';
import 'package:junto_beta_mobile/providers/spheres_provider/spheres_provider.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/loading_screen/junto_loading_screen.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:provider/provider.dart';

import 'providers/collective_provider/collective_provider.dart';

class JuntoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoAppState();
  }
}

class JuntoAppState extends State<JuntoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        Provider<SearchProvider>(
          builder: (BuildContext context) => SearchProvider(),
        ),
        Provider<AuthenticationProvider>(
          builder: (BuildContext context) => AuthenticationImp(),
        ),
        ChangeNotifierProvider<CollectiveProvider>(
          builder: (BuildContext context) => CollectiveProvider(),
        ),
        ChangeNotifierProvider<SpheresProvider>(
          builder: (BuildContext context) => SpheresProvider(),
        ),
        ChangeNotifierProvider<PacksProvider>(
          builder: (BuildContext context) => PacksProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Avenir',
        ),
        home: JuntoLoading(),
        routes: <String, WidgetBuilder>{
          '/welcome': (BuildContext context) => Welcome(),
          '/template': (BuildContext context) => JuntoTemplate(),
          '/create': (BuildContext context) => const JuntoCreate('collective'),
          '/notifications': (BuildContext context) => JuntoNotifications(),
        },
      ),
    );
  }
}
