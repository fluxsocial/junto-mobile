import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PackRequest extends StatelessWidget {
  const PackRequest({this.pack, this.refreshGroups});

  final Group pack;
  final Function refreshGroups;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // FIXME:ERIC - waiting on API to return creator address and info

        // JuntoLoader.showLoader(context);
        // try {
        //   final UserData packOwnerUserData =
        //       await Provider.of<UserRepo>(context, listen: false)
        //           .getUser(pack.creator);
        //   JuntoLoader.hide();
        //   Navigator.push(
        //     context,
        //     CupertinoPageRoute<dynamic>(
        //       builder: (BuildContext context) =>
        //           JuntoMember(profile: packOwnerUserData.user),
        //     ),
        //   );
        // } catch (error) {
        //   print(error);
        //   JuntoLoader.hide();
        // }
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
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(CustomIcons.packs, size: 15, color: Colors.white)),
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
                          pack.groupData.name,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text('username',
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
                                  .respondToGroupRequest(pack.address, true);
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
                                  .respondToGroupRequest(pack.address, false);
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
