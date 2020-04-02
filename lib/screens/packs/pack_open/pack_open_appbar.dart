import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_action_items.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:feature_discovery/feature_discovery.dart';
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
                    ? Row(
                        children: <Widget>[
                          MemberAvatar(
                            diameter: 28,
                            profilePicture:
                                pack.address == userProfile.pack.address
                                    ? userProfile.user.profilePicture
                                    : pack.creator['profile_picture'],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            pack.address == userProfile.pack.address
                                ? 'My Pack'
                                : pack.groupData.name,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
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
                    GestureDetector(
                      onTap: () {
                        FeatureDiscovery.clearPreferences(context, <String>{
                          'packs_info_id',
                          // 'collective_filter_id',
                          'packs_toggle_id',
                        });
                        FeatureDiscovery.discoverFeatures(
                          context,
                          const <String>{
                            'packs_info_id',
                            // 'collective_filter_id',
                            'packs_toggle_id',
                          },
                        );
                      },
                      child: JuntoDescribedFeatureOverlay(
                        icon: Icon(
                          CustomIcons.newpacks,
                          size: 36,
                          color: Colors.white,
                        ),
                        featureId: 'packs_info_id',
                        title:
                            'This is your Pack. It displays all of the publicly shared posts from you and the people you choose to have in you pack. There is also a section where you can share things privately to just your pack members.',
                        learnMore: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: JuntoInfoIcon(),
                        ),
                      ),
                    ),
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
