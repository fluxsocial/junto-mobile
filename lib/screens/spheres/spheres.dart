import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_preview/sphere_preview.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/providers/spheres_provider/spheres_provider.dart';

// This class renders the main screen for Spheres. It includes a widget to create
// a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          // Create sphere
          // SpheresCreate(),

          // List of spheres member belongs to
          Consumer<SpheresProvider>(
            builder: (context, spheres, child) {
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: spheres.spheres
                    .map(
                      (sphere) => SpherePreview(
                            sphere.sphereTitle,
                            sphere.sphereMembers,
                            sphere.sphereImage,
                            sphere.sphereHandle,
                            sphere.sphereDescription,
                          ),
                    )
                    .toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
