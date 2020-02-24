import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class SphereRequest extends StatelessWidget {
  const SphereRequest({this.sphere, this.refreshGroups});

  final Group sphere;
  final Function refreshGroups;
  @override
  Widget build(BuildContext context) {
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
                          's/' + sphere.groupData.sphereHandle,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(sphere.groupData.name,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            JuntoLoader.showLoader(context);
                            try {
                              await Provider.of<GroupRepo>(context,
                                      listen: false)
                                  .respondToGroupRequest(sphere.address, true);
                              refreshGroups();
                              JuntoLoader.hide();
                            } catch (error) {
                              print(error);
                              JuntoLoader.hide();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                            ),
                            height: 38,
                            width: 38,
                            child: Icon(CustomIcons.check,
                                size: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            JuntoLoader.showLoader(context);
                            try {
                              await Provider.of<GroupRepo>(context,
                                      listen: false)
                                  .respondToGroupRequest(sphere.address, false);
                              refreshGroups();
                              JuntoLoader.hide();
                            } catch (error) {
                              print(error);
                              JuntoLoader.hide();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                            ),
                            height: 38,
                            width: 38,
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
