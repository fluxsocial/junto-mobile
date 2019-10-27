import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';

// This class renders a preview of a sphere
class SpherePreview extends StatelessWidget {
  const SpherePreview({@required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) {
              return SphereOpen(
                group: group,
              );
            },
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
                    'assets/images/junto-mobile__placeholder--sphere.png',
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
                      Text(
                        's/' + group.groupData.sphereHandle,
                        textAlign: TextAlign.start,
                        style: JuntoStyles.title,
                      ),
                      Text(
                        group.groupData.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff555555),
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
