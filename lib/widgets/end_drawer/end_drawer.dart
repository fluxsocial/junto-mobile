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
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_account.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/utils/app_version_label.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

import 'junto_center.dart';
import 'junto_invite.dart';
import 'junto_themes_page.dart';

class JuntoDrawer extends StatefulWidget {
  @override
  _JuntoDrawerState createState() => _JuntoDrawerState();
}

class _JuntoDrawerState extends State<JuntoDrawer> {
  void _onLogOut() async {
    try {
      await context.bloc<AuthBloc>().add(LogoutEvent());
    } catch (e) {
      logger.logException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider, JuntoThemesProvider>(
      builder: (BuildContext context, UserDataProvider user,
          JuntoThemesProvider theme, Widget child) {
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
                  top: MediaQuery.of(context).size.height * .12,
                  left: 32,
                  bottom: MediaQuery.of(context).size.height * .12,
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
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 32),
                              child: MemberAvatar(
                                profilePicture:
                                    user.userProfile.user.profilePicture,
                                diameter: 28,
                              ),
                            ),
                            title: S.of(context).menu_my_den,
                            theme: theme,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                FadeRoute<void>(
                                  child: JuntoDen(),
                                ),
                              );
                            },
                          ),
                        JuntoDrawerItem(
                          icon: CustomIcons.infinity,
                          iconSize: 9,
                          title: S.of(context).menu_relations,
                          theme: theme,
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
                          icon: CustomIcons.themes,
                          title: S.of(context).themes_title,
                          theme: theme,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return JuntoThemesPage();
                                },
                              ),
                            );
                          },
                        ),
                        JuntoDrawerItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: Image.asset(
                              'assets/images/junto-mobile__sprout.png',
                              height: 20,
                              color: JuntoPalette().juntoWhite(theme: theme),
                            ),
                          ),
                          title: 'Center',
                          theme: theme,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return JuntoCommunityCenter();
                                },
                              ),
                            );
                          },
                        ),
                        JuntoDrawerItem(
                          icon: Icons.mail_outline,
                          title: 'Invite',
                          theme: theme,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return JuntoInvite();
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
                        // theme: theme,
                        //
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
                    Column(
                      children: <Widget>[
                        JuntoDrawerItem(
                          icon: Icons.person_outline,
                          title: 'Account',
                          theme: theme,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return JuntoAccount();
                                },
                              ),
                            );
                          },
                        ),
                        JuntoDrawerItem(
                          icon: Icons.settings,
                          title: S.of(context).menu_logout,
                          theme: theme,
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                buildContext: context,
                                confirm: _onLogOut,
                                confirmationText:
                                    S.of(context).menu_are_you_sure_to_logout,
                              ),
                            );
                          },
                        ),
                      ],
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
    @required this.theme,
    this.iconSize = 24,
  }) : super(key: key);

  final dynamic icon;
  final double iconSize;
  final String title;
  final VoidCallback onTap;
  final JuntoThemesProvider theme;

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
              icon.runtimeType == IconData
                  ? Container(
                      width: 60,
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        icon,
                        color: JuntoPalette().juntoWhite(theme: theme),
                        size: iconSize,
                      ),
                    )
                  : icon,
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: JuntoPalette().juntoWhite(theme: theme),
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
