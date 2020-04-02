import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_action_items.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';

import 'package:provider/provider.dart';

class PackOpenAppbar extends StatelessWidget {
  const PackOpenAppbar({
    Key key,
    @required this.pack,
  }) : super(key: key);

  final Group pack;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, user, child) {
        final userProfile = user.userProfile;
        return AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[Container()],
          brightness: Theme.of(context).brightness,
          elevation: 0,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                userProfile != null
                    ? Flexible(
                        child: Row(
                          children: <Widget>[
                            MemberAvatar(
                              diameter: 28,
                              profilePicture:
                                  pack.address == userProfile.pack.address
                                      ? userProfile.user.profilePicture
                                      : pack.creator['profile_picture'],
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                pack.address == userProfile.pack.address
                                    ? 'My Pack'
                                    : pack.groupData.name,
                                style: Theme.of(context).textTheme.headline6,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => NotificationsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 38,
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          CustomIcons.moon,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    userProfile != null &&
                            userProfile.pack.address != pack.address
                        ? GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                builder: (BuildContext context) =>
                                    PackOpenActionItems(
                                  pack: pack,
                                  userProfile: userProfile,
                                ),
                              );
                            },
                            child: Container(
                              width: 38,
                              alignment: Alignment.centerRight,
                              color: Colors.transparent,
                              child: Icon(
                                CustomIcons.morevertical,
                                size: 22,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
