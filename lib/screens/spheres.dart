
import 'package:flutter/material.dart';

// typography
import './../palette.dart';

// app bar + bottom nav
import '../components/appbar/appbar.dart';
import '../components/appbar_border/appbar_border.dart';
import './../components/bottom_nav/bottom_nav.dart';

// sphere preview + model
import '../models/sphere.dart';
import './spheres/sphere_preview.dart';


class JuntoSpheres extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _JuntoSpheresState();
  }
}

class _JuntoSpheresState extends State {
  List spheres; 
  @override
  void initState() {
    super.initState();

    spheres = Sphere.fetchSphere();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: juntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--spheres.png', 'SPHERES'),

        body: Column(
          children: <Widget>[
            // App bar border
            AppbarBorder(JuntoPalette.juntoGreen),
            
            Container(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                width: 1000,
                color: Colors.white,
                foregroundDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.grey),
                  ),
                ),
                child: Row(children: [
                  IconButton(
                    onPressed: () {},
                    color: Colors.blue,
                    alignment: Alignment(-1.0, 0),
                    icon: Icon(Icons.search),
                    padding: EdgeInsets.all(0.0),
                  ),
                  Text('search spheres',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))
                ]),),

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
