
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/scoped_user.dart';
import './spheres__create/spheres__create.dart';
import './sphere_preview.dart';

class JuntoSpheres extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return 
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
                    children: model.spheres.map((sphere) => SpherePreview(sphere.sphereTitle, sphere.sphereMembers, sphere.sphereImage)).toList()
                  )
                )                                
              ],
            ),
        );
        
  }
}
