
import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import '../../models/sphere.dart';
import './spheres__create/spheres__create.dart';
import './sphere_preview.dart';
import './../../typography/palette.dart';

class JuntoSpheres extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JuntoSpheresState();
  }
}

class _JuntoSpheresState extends State {
  List spheres; 
  @override
  void initState() {
    super.initState();

    spheres = Sphere.fetchAll();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--spheres.png', 'SPHERES', JuntoPalette.juntoGreen),

        body: 
        Container(          
          child: 
            ListView(
              children: <Widget>[
                // Create sphere
                SpheresCreate(),

                // List of spheres member belongs to
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: spheres.map((sphere) => SpherePreview(sphere.sphereTitle, sphere.sphereMembers)).toList()
                  )
                                
              ],
            ),
          ),

        bottomNavigationBar: BottomNav());
  }
}
