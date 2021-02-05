import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_button.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/profile_picture_avatar.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_item.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/bio.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_placeholder.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_photo.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/badges_row.dart';

class JuntoDenSliverAppbar extends StatefulWidget {
  const JuntoDenSliverAppbar({Key key, @required this.profile})
      : super(key: key);

  final UserData profile;

  @override
  State<StatefulWidget> createState() {
    return JuntoDenSliverAppbarState();
  }
}

class JuntoDenSliverAppbarState extends State<JuntoDenSliverAppbar>
    with WidgetsBindingObserver {
  double _flexibleHeightSpace;
  final GlobalKey<JuntoDenSliverAppbarState> _keyFlexibleSpace =
      GlobalKey<JuntoDenSliverAppbarState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    if (_flexibleHeightSpace != heightFlexibleSpace) {
      setState(() {
        _flexibleHeightSpace = heightFlexibleSpace;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.profile.user.backgroundPhoto;
    final name = widget.profile.user.name.trim();

    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
      backgroundColor: Theme.of(context).backgroundColor,
      brightness: Theme.of(context).brightness,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (photo != null && (photo.isNotEmpty || photo != ''))
                    MemberBackgroundPhoto(profile: widget.profile),
                  if (photo == null || photo.isEmpty)
                    MemberBackgroundPlaceholder(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<dynamic>(
                          builder: (BuildContext context) => AboutMember(
                            profile: widget.profile,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      key: _keyFlexibleSpace,
                      margin: const EdgeInsets.only(top: 35),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 3,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              // Member Badges
                              if (widget.profile.user.badges != null)
                                if (widget.profile.user.badges.isNotEmpty)
                                  MemberBadgesRow(
                                    badges: widget.profile.user.badges,
                                  ),
                            ],
                          ),
                          if (widget.profile.user.gender[0] != '' &&
                              widget.profile.user.location[0] != '' &&
                              widget.profile.user.website[0] != '')
                            const SizedBox(height: 10),
                          AboutItem(
                            item: widget.profile.user.gender,
                            icon: Icon(
                              CustomIcons.gender,
                              size: 17,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          AboutItem(
                            item: widget.profile.user.location,
                            icon: Image.asset(
                              'assets/images/junto-mobile__location.png',
                              height: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          AboutItem(
                            item: widget.profile.user.website,
                            isWebsite: true,
                            icon: Image.asset(
                              'assets/images/junto-mobile__link.png',
                              height: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          MemberBio(profile: widget.profile)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MemberProfilePictureAvatar(
              profile: widget.profile,
            ),
            EditDenButton(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) => JuntoEditDen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      expandedHeight: _flexibleHeightSpace == null
          ? 1000
          : _flexibleHeightSpace + MediaQuery.of(context).size.width / 2 + .75,
      forceElevated: false,
    );
  }
}
