
import 'package:flutter/material.dart';

// typography
import './../../typography/palette.dart';

// app bar + bottom nav
import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';

// sphere preview + model
import '../../models/sphere.dart';
import './sphere_preview.dart';
import '../../components/filter/filter_spheres/filter_spheres.dart';


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

        body: Column(
          children: <Widget>[
            // Search spheres text field
            FilterSpheres(),

            // List of spheres member belongs to
            Expanded(
              child: ListView(
                children: spheres.map((sphere) => SpherePreview(sphere.sphereTitle, sphere.sphereMembers)).toList()
              )
            )                    
          ],
        ),
        bottomNavigationBar: BottomNav());
  }
}
