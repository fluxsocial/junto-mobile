import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/sphere_open/sphere_open.dart';

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
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.3, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    CustomIcons.spheres,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 17,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 75,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: .5,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('s/' + group.groupData.sphereHandle,
                          textAlign: TextAlign.start, style: Theme.of(context).textTheme.subhead),
                      Text(group.groupData.name, textAlign: TextAlign.start, style: Theme.of(context).textTheme.body1)
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
