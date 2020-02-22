import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

// This class renders a preview of a sphere
class SpherePreview extends StatelessWidget {
  const SpherePreview({@required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          group.groupData.photo == ''
              ? Container(
                  alignment: Alignment.center,
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.3, 0.9],
                      colors: <Color>[
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    CustomIcons.spheres,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 17,
                  ),
                )
              : ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: group.groupData.photo,
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: const <double>[0.3, 0.9],
                              colors: <Color>[
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            CustomIcons.spheres,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 17,
                          ),
                        );
                      }),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: .5,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('s/' + group.groupData.sphereHandle,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle1),
                  Text(group.groupData.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
