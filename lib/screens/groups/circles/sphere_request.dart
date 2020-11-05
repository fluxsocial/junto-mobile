import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class SphereRequest extends StatelessWidget {
  const SphereRequest({this.item, this.diameter = 38});

  final JuntoNotification item;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    print(item.group.groupData.sphereHandle);
    return GestureDetector(
      onTap: () async {
        // display sphere
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: diameter,
              width: diameter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const <double>[0.3, 0.9],
                  colors: <Color>[
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary
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
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          's/${item.group.groupData.sphereHandle}',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(item.group.groupData.name,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            // Accept request
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                            ),
                            height: 33,
                            width: 33,
                            child: Icon(CustomIcons.check,
                                size: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            // Decline request
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                            ),
                            height: 33,
                            width: 33,
                            child: Icon(CustomIcons.cancel,
                                size: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
