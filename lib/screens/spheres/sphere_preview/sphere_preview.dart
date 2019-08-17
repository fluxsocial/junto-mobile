import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open.dart';

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
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => SphereOpen(
              sphereTitle,
              sphereMembers,
              sphereImage,
              sphereHandle,
              sphereDescription,
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
                        color: Color(
                          0xffeeeeee,
                        ),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        sphereTitle,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '/s/' + sphereHandle,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
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
