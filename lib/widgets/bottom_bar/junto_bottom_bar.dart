import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:provider/provider.dart';

class JuntoBottomBar extends StatelessWidget {
  JuntoBottomBar({
    this.userData,
    this.currentScreen,
  });

  final UserData userData;
  final Screen currentScreen;

  Future<void> changeScreen(BuildContext context, Screen screen) async {
    await Provider.of<AppRepo>(context, listen: false)
        .changeScreen(screen: screen);
  }

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
      padding: EdgeInsets.only(
          bottom: Platform.isAndroid
              ? MediaQuery.of(context).viewPadding.bottom
              : 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final appRepo =
                    await Provider.of<AppRepo>(context, listen: false);

                if (appRepo.groupsPageIndex == 1 &&
                    appRepo.currentScreen == Screen.groups) {
                  Provider.of<AppRepo>(context, listen: false)
                      .setGroupsPageIndex(0);
                } else {
                  changeScreen(context, Screen.groups);
                }
              },
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.newcollective,
                  size: 33,
                  color: currentScreen == Screen.groups
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => changeScreen(context, Screen.create),
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.newcreate,
                  size: 38,
                  color: currentScreen == Screen.create
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
                      height: 33,
                      width: 33,
                      child: MemberAvatar(
                        profilePicture: userData.user.profilePicture,
                        diameter: 33,
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
