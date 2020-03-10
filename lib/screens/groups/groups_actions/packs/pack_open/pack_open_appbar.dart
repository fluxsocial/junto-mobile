import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

class PackOpenAppbar extends StatelessWidget {
  const PackOpenAppbar({
    Key key,
    @required this.pack,
    @required this.userProfile,
  }) : super(key: key);

  final Group pack;
  final UserData userProfile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      brightness: Brightness.light,
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
                        profilePicture: pack.address == userProfile.pack.address
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
                  onTap: () {},
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
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => Container(
                        color: const Color(0xff737373),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .1,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Row(
                                        children: <Widget>[
                                          Text(
                                            '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: Row(
                                        children: <Widget>[
                                          Text(
                                            '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
