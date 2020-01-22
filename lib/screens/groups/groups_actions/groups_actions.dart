import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/spheres.dart';

class JuntoGroupsActions extends StatefulWidget {
  const JuntoGroupsActions({this.userProfile, this.changeGroup});

  final UserData userProfile;
  final Function changeGroup;
  @override
  State<StatefulWidget> createState() {
    return JuntoGroupsActionsState();
  }
}

class JuntoGroupsActionsState extends State<JuntoGroupsActions> {
  bool spheresVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height - 90,
            child: Stack(children: <Widget>[
              spheresVisible
                  ? Spheres(changeGroup: widget.changeGroup)
                  : Packs(
                      userProfile: widget.userProfile,
                      changeGroup: widget.changeGroup,
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).backgroundColor,
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: .75)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              spheresVisible = false;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(CustomIcons.packs,
                                      size: 20,
                                      color: spheresVisible
                                          ? Theme.of(context).primaryColorLight
                                          : Theme.of(context).primaryColorDark),
                                  const SizedBox(height: 7),
                                  Text('PACKS',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: spheresVisible
                                              ? Theme.of(context)
                                                  .primaryColorLight
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                          decoration: TextDecoration.none))
                                ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              spheresVisible = true;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    CustomIcons.spheres,
                                    size: 20,
                                    color: spheresVisible
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(context).primaryColorLight,
                                  ),
                                  const SizedBox(height: 7),
                                  Text('SPHERES',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: spheresVisible
                                              ? Theme.of(context)
                                                  .primaryColorDark
                                              : Theme.of(context)
                                                  .primaryColorLight,
                                          decoration: TextDecoration.none))
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ])),
      ],
    );
  }
}
