import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../collective/perspectives/perspectives.dart';
import '../collective/collective.dart';
import '../spheres/spheres.dart';
import '../pack/pack.dart';
import '../den/den.dart';
import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import './../../components/expression_preview/expression_preview.dart';
import '../../scoped_models/scoped_user.dart';
import '../../typography/palette.dart';

class JuntoTemplate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoTemplateState();
  }
}

class JuntoTemplateState extends State<JuntoTemplate> {
  var _currentScreen; 

  String _currentPerspective = 'JUNTO';
  String _appbarLogo = 'assets/images/junto-mobile__logo--collective.png';
  String _appbarTitle = 'JUNTO';
  Color _appbarBorderLeft = JuntoPalette.juntoBlue;
  Color _appbarBorderRight = JuntoPalette.juntoBlueLight;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return 
    ScopedModelDescendant<ScopedUser>(
      builder: (context, child, model) =>
        Scaffold(
            appBar: JuntoAppBar.getJuntoAppBar(
                _appbarLogo, _appbarTitle, _appbarBorderLeft,
                _appbarBorderRight, _navPerspectives),
            drawer: model.currentScreen == 'collective' ? Perspectives(_changePerspective) : null,
            body: PageView(
              children: <Widget>[
                JuntoCollective(),
                JuntoSpheres(),
                JuntoPack(),
                JuntoDen()
              ],
            ),
            bottomNavigationBar: BottomNav('collective'),
        )
    );
  }

  void _setCurrentScreen(screen) {
    setState(() {
      ScopedModelDescendant<ScopedUser>(context, child, model) => 
      model.setScreen('collective');
    });
  }

  _navPerspectives() {
    return;
  }

  _changePerspective() {
    return;
  }
}
