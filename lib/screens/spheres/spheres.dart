
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/scoped_user.dart';
import './spheres__create/spheres__create.dart';
import './sphere_preview/sphere_preview.dart';

// This class renders the main screen for Spheres. It includes a widget to create
// a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
        Container(          
          child: 
            ListView(
              children: <Widget>[
                // Create sphere
                // SpheresCreate(),

                // List of spheres member belongs to
                ScopedModelDescendant<ScopedUser> (
                  builder: (context, child, model) => 
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: model.spheres.map((sphere) => SpherePreview(sphere.sphereTitle, sphere.sphereMembers, sphere.sphereImage, sphere.sphereHandle)).toList()
                  )
                )                                
              ],
            ),
        );      
  }
}
