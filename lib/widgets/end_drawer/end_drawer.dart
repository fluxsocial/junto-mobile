import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_event.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_resources.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/utils/app_version_label.dart';
import 'package:provider/provider.dart';

import 'junto_themes_page.dart';

class JuntoDrawer extends StatelessWidget {
  Future<void> _onLogOut(BuildContext context) async {
    try {
      await context.bloc<AuthBloc>().add(LogoutEvent());
      Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      logger.logException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (BuildContext context, UserDataProvider user, Widget child) {
        return Stack(
          children: <Widget>[
            BackgroundTheme(),
            Positioned(
              bottom: 0,
              right: 0,
              child: AppVersionLabel(),
            ),
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .2,
                  left: 32,
                  bottom: MediaQuery.of(context).size.height * .2,
                  right: 32,
                ),
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        if (user.userProfile?.user != null)
                          JuntoDrawerItem(
                            icon: Container(
                              margin: const EdgeInsets.only(right: 32),
                              child: MemberAvatar(
                                profilePicture:
                                    user.userProfile.user.profilePicture,
                                diameter: 28,
                              ),
                            ),
                            title: S.of(context).menu_my_den,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                FadeRoute<void>(
                                  child: JuntoDen(),
                                ),
                              );
                            },
                          ),
                        // Eric - Leaving this here while we test out global search
                        // in bottom nav

                        // JuntoDrawerItem(
                        //   icon: Container(
                        //     width: 60,
                        //     alignment: Alignment.centerLeft,
                        //     child: Icon(
                        //       Icons.search,
                        //       color: Colors.white,
                        //       size: 24,
                        //     ),
                        //   ),
                        //   title: S.of(context).menu_search,
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       CupertinoPageRoute<Widget>(
                        //         builder: (BuildContext context) {
                        //           return GlobalSearch();
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),
                        JuntoDrawerItem(
                          icon: Container(
                            width: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              CustomIcons.infinity,
                              color: Colors.white,
                              size: 9,
                            ),
                          ),
                          title: S.of(context).menu_relations,
                          onTap: () {
                            // open relationships
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return FeatureDiscovery(
                                    child: JuntoRelationships(
                                      user.userAddress,
                                      user.userProfile.userPerspective.address,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        JuntoDrawerItem(
                          icon: Container(
                            width: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          title: S.of(context).themes_title,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return JuntoThemesPage();
                                },
                              ),
                            );
                          },
                        ),

                        // To Do: Eric
                        // JuntoDrawerItem(
                        //   icon: Container(
                        //     width: 60,
                        //     alignment: Alignment.centerLeft,
                        //     child: Icon(
                        //       Icons.book,
                        //       color: Colors.white,
                        //       size: 24,
                        //     ),
                        //   ),
                        //   title: 'Resources',
                        //   onTap: () async {
                        //     await Navigator.push(
                        //       context,
                        //       CupertinoPageRoute<dynamic>(
                        //         builder: (BuildContext context) {
                        //           return JuntoResources();
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                    Container(
                      child: JuntoDrawerItem(
                        icon: Container(
                          width: 60,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: S.of(context).menu_logout,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => ConfirmDialog(
                              buildContext: context,
                              confirm: () => _onLogOut(context),
                              confirmationText:
                                  S.of(context).menu_are_you_sure_to_logout,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class JuntoDrawerItem extends StatelessWidget {
  const JuntoDrawerItem({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15 / MediaQuery.of(context).textScaleFactor,
          ),
          child: Row(
            children: <Widget>[
              icon,
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
