
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import '../../scoped_models/scoped_user.dart';
import './spheres__create/spheres__create.dart';
import './sphere_preview.dart';
import './../../typography/palette.dart';

class JuntoSpheres extends StatelessWidget {
  void noNav() {
    return ;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--spheres.png', 'SPHERES', 
        JuntoPalette.juntoGreen, JuntoPalette.juntoGreenLight, noNav),

        body: 
        Container(          
          child: 
            ListView(
              children: <Widget>[
                // Create sphere
                SpheresCreate(),

                ScopedModelDescendant<ScopedUser> (
                // List of spheres member belongs to
                  builder: (context, child, model) => 
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: model.spheres.map((sphere) => SpherePreview(sphere.sphereTitle, sphere.sphereMembers)).toList()
                  )
                )                                
              ],
            ),
          ),

        bottomNavigationBar: BottomNav('spheres'));
  }
}
