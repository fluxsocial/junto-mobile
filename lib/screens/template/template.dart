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
  var _currentScreen = 'collective';
  String _currentPerspective = 'JUNTO';
  String _appbarLogo = 'assets/images/junto-mobile__logo--collective.png';
  String _appbarTitle = 'JUNTO';
  Color _appbarBorderLeft = JuntoPalette.juntoBlue;
  Color _appbarBorderRight = JuntoPalette.juntoBlueLight;

  final controller = PageController(
    initialPage: 1
  );

  _createAppBarTitle() {
    return 'collective';
  }


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
            drawer: Perspectives(_changePerspective),
            body: 
              PageView(      
                controller: controller,          
                onPageChanged: (int) {
                  if(int == 0) {
                    setState(() {
                      _currentScreen = 'collective';
                      _appbarTitle = 'JUNTO';
                      _appbarLogo = 'assets/images/junto-mobile__logo--collective.png';
                      _appbarBorderLeft = JuntoPalette.juntoBlue;
                      _appbarBorderRight = JuntoPalette.juntoBlueLight;                    
                    });
                  } else if(int == 1) {
                    setState(() {
                      _currentScreen = 'spheres';
                      _appbarTitle = 'SPHERES';
                      _appbarLogo = 'assets/images/junto-mobile__logo--spheres.png';
                      _appbarBorderLeft = JuntoPalette.juntoGreen;
                      _appbarBorderRight = JuntoPalette.juntoGreenLight;                     
                    });
                  } else if(int == 2) {
                    setState(() {
                      _currentScreen = 'packs';
                      _appbarTitle = 'PACKS';
                      _appbarLogo = 'assets/images/junto-mobile__logo--pack.png';
                      _appbarBorderLeft = JuntoPalette.juntoPurple;
                      _appbarBorderRight = JuntoPalette.juntoPurpleLight;                     
                    });
                  } else if(int == 3) {
                    setState(() {
                      _currentScreen = 'den';
                      _appbarTitle = 'DEN';
                      _appbarLogo = 'assets/images/junto-mobile__logo--den.png';
                      _appbarBorderLeft = JuntoPalette.juntoGrey;
                      _appbarBorderRight = JuntoPalette.juntoSleek; 
                    });
                  } 
                },
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


  _navPerspectives() {
    return;
  }

  _changePerspective() {
    return;
  }
}
