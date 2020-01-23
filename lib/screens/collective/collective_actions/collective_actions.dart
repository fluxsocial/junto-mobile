import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/perspectives.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/channels.dart';

class JuntoCollectiveActions extends StatefulWidget {
  const JuntoCollectiveActions({this.userProfile, this.changePerspective});

  final UserData userProfile;
  final Function changePerspective;

  @override
  State<StatefulWidget> createState() {
    return JuntoCollectiveActionsState();
  }
}

class JuntoCollectiveActionsState extends State<JuntoCollectiveActions> {
  bool channelsVisible = false;

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
              channelsVisible
                  ? JuntoChannels()
                  : JuntoPerspectives(userProfile: widget.userProfile, changePerspective: widget.changePerspective),
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
                              channelsVisible = false;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/junto-mobile__binoculars.png',
                                    height: 20,
                                    color: channelsVisible
                                        ? Theme.of(context).primaryColorLight
                                        : Theme.of(context).primaryColorDark,
                                  ),
                                  // Icon(CustomIcons.packs,
                                  //     size: 20,
                                  //     color: channelsVisible
                                  //         ? Theme.of(context).primaryColorLight
                                  //         : Theme.of(context).primaryColorDark),
                                  const SizedBox(height: 7),
                                  Text('PERSPECTIVES',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: channelsVisible
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
                              channelsVisible = true;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    CustomIcons.hash,
                                    size: 20,
                                    color: channelsVisible
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(context).primaryColorLight,
                                  ),
                                  const SizedBox(height: 7),
                                  Text('CHANNELS',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: channelsVisible
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
