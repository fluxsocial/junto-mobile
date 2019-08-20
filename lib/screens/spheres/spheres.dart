import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/screens/spheres/create_sphere/create_sphere.dart';
import 'package:junto_beta_mobile/providers/spheres_provider/spheres_provider.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_preview/sphere_preview.dart';
import 'package:provider/provider.dart';

/// This class renders the main screen for Spheres. It includes a widget to
/// create
/// a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          // Create sphere
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Create a sphere',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSphere(),
                      ),
                    );
                  },
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ],
            ),
          ),

          // List of spheres member belongs to
          Consumer<SpheresProvider>(
            builder:
                (BuildContext context, SpheresProvider spheres, Widget child) {
              return ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: spheres.spheres
                    .map(
                      (Sphere sphere) => SpherePreview(
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
