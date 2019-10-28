import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

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
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 38.0,
                width: 38.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const <double>[0.3, 0.9],
                    colors: <Color>[
                      JuntoPalette.juntoSecondary,
                      JuntoPalette.juntoPrimary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  CustomIcons.spheres,
                  color: Colors.white,
                  size: 15,
                ),
              ),
                Container(
                  width: MediaQuery.of(context).size.width - 68,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,                    
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
