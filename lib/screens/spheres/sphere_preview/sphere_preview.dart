import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

// This class renders a preview of a sphere
class SpherePreview extends StatelessWidget {
  const SpherePreview(
    this.sphereTitle,
    this.sphereMembers,
    this.sphereImage,
    this.sphereHandle,
    this.sphereDescription,
  );

  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;
  final String sphereHandle;
  final String sphereDescription;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => SphereOpen(
                  sphereTitle: sphereTitle,
                  sphereMembers: sphereMembers,
                  sphereImage: sphereImage,
                  sphereHandle: sphereHandle,
                  sphereDescription: sphereDescription,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(
                  child: Image.asset(
                    sphereImage,
                    height: 45.0,
                    width: 45.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 65,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: .5,
                        color: JuntoPalette.juntoFade,
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(sphereTitle,
                          textAlign: TextAlign.start, style: JuntoStyles.title),
                      Text('/s/' + sphereHandle,
                          textAlign: TextAlign.start, style: JuntoStyles.body)
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
