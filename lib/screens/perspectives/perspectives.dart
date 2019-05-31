
import 'package:flutter/material.dart';

import '../../components/appbar/appbar.dart';
import '../../components/bottom_nav/bottom_nav.dart';
import '../../models/perspective.dart';
import './perspectives__create/perspectives__create.dart';
import './perspective_preview.dart';
import './../../typography/palette.dart';

class JuntoPerspectives extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JuntoPerspectivesState();
  }
}

class _JuntoPerspectivesState extends State {
  List perspectives;

  @override
  void initState() {
    super.initState();

    perspectives = Perspective.fetchAll();
  }

  void noNav() {
    return ;
  }
  @override
  Widget build(BuildContext context) {  

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--den.png', 'PERSPECTIVES', 
      JuntoPalette.juntoGrey, JuntoPalette.juntoSleek, noNav),

        body: ListView(
          children: <Widget>[        

            PerspectivesCreate(),

            ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children:               
                perspectives.map((perspective) => 
                PerspectivePreview(perspective.perspectiveTitle)).toList(),
            )                          
          ],
        ),

        bottomNavigationBar: BottomNav(),
    );
  }
}
