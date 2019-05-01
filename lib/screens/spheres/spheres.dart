
import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import '../../models/sphere.dart';
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
                Container(
                  height: 75,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Create a Sphere', style: TextStyle(color: JuntoPalette.juntoGrey, fontSize: 14, fontWeight: FontWeight.w700)),
                      Container(
                        child: Icon(Icons.add_circle_outline, size: 17, color: JuntoPalette.juntoGrey)
                      )
                    ])
                ),

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
