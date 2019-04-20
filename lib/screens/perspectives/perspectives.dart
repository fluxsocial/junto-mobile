
import 'package:flutter/material.dart';

// typography
import './../../typography/palette.dart';

// app bar + bottom nav
import '../../components/appbar/appbar.dart';
import '../../components/appbar/appbar_border/appbar_border.dart';
import '../../components/bottom_nav/bottom_nav.dart';

// perspective view + model
import '../../models/perspective.dart';
import './perspective_preview.dart';

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

    perspectives = Perspective.fetchPerspective();
  }

  @override
  Widget build(BuildContext context) {  

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: juntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--den.png', 'PERSPECTIVES'),

        body: Column(
          children: <Widget>[
            
            // App bar border
            AppbarBorder(JuntoPalette.juntoGrey),

            // Expanded(child: ListView(
            //   children: 
            //     // Collective perspective widget
            //     PerspectiveTemplate('COLLECTIVE'),

            //     // Selective perspective widget
            //     PerspectiveTemplate('SELECTIVE'),

            //     perspectives.map((perspective) => PerspectiveTemplate(perspective.perspectiveTitle)).toList(),


              
            // ),)
            PerspectivePreview('COLLECTIVE'),
              

              Expanded(
                child: ListView(
                children:               
                  perspectives.map((perspective) => 
                  PerspectivePreview(perspective.perspectiveTitle)).toList(),
              ))                
            
          ],
        ),

        bottomNavigationBar: BottomNav(),
    );
  }
}
