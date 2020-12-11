import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';

class JuntoBottomBar extends StatelessWidget {
  JuntoBottomBar({
    this.userData,
    this.changeScreen,
    this.currentScreen,
  });

  final UserData userData;
  final Function changeScreen;
  final Screen currentScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => changeScreen(Screen.collective),
              child: Container(
                color: Colors.transparent,
                height: 60,
                child: Icon(
                  CustomIcons.newcollective,
                  size: 28,
                  color: currentScreen == Screen.collective
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => changeScreen(Screen.groups),
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.newcircles,
                  size: 28,
                  color: currentScreen == Screen.groups
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => changeScreen(Screen.create),
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.newcreate,
                  size: 28,
                  color: currentScreen == Screen.create
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => changeScreen(Screen.packs),
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.newpacks,
                  size: 28,
                  color: currentScreen == Screen.packs
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => JuntoFilterDrawer.of(context).toggleRightMenu(),
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 28,
                      width: 28,
                      child: MemberAvatar(
                        profilePicture: userData.user.profilePicture,
                        diameter: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
