import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/screens/member/member_relation_button.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_item.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/bio.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/profile_picture_avatar.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_placeholder.dart';

class MemberDenAppbar extends StatefulWidget {
  const MemberDenAppbar(
      {Key key,
      @required this.profile,
      @required this.isConnected,
      @required this.toggleMemberRelationships,
      this.isFollowing})
      : super(key: key);

  final UserProfile profile;
  final bool isConnected;
  final bool isFollowing;
  final Function toggleMemberRelationships;

  @override
  State<StatefulWidget> createState() {
    return MemberDenAppbarState();
  }
}

class MemberDenAppbarState extends State<MemberDenAppbar> {
  final GlobalKey<MemberDenAppbarState> _keyFlexibleSpace =
      GlobalKey<MemberDenAppbarState>();

  String _currentTheme;
  UserData _memberProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
    getCurrentTheme();
    _memberProfile = UserData(
      user: widget.profile,
      pack: null,
      connectionPerspective: null,
      userPerspective: null,
      privateDen: null,
      publicDen: null,
    );
  }

  double _flexibleHeightSpace;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  Future<void> getCurrentTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTheme = prefs.getString('current-theme');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[
        SizedBox(
          height: 0,
          width: 0,
        )
      ],
      backgroundColor: Theme.of(context).backgroundColor,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MemberBackgroundPlaceholder(theme: _currentTheme),
                  Container(
                    key: _keyFlexibleSpace,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  widget.profile.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              MemberRelationButton(
                                toggleMemberRelationships:
                                    widget.toggleMemberRelationships,
                              ),
                            ]),
                        if (widget.profile.gender.isNotEmpty ||
                            widget.profile.location.isNotEmpty ||
                            widget.profile.website.isNotEmpty)
                          const SizedBox(height: 15),
                        AboutItem(
                          item: widget.profile.gender,
                          icon: Icon(
                            CustomIcons.gender,
                            size: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        AboutItem(
                          item: widget.profile.location,
                          icon: Image.asset(
                            'assets/images/junto-mobile__location.png',
                            height: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        AboutItem(
                          item: widget.profile.website,
                          icon: Image.asset(
                            'assets/images/junto-mobile__link.png',
                            height: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (_memberProfile != null)
                          MemberBio(
                            profile: _memberProfile,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_memberProfile != null)
              MemberProfilePictureAvatar(profile: _memberProfile),
          ],
        ),
      ),
      expandedHeight: _flexibleHeightSpace == null
          ? 1000
          : _flexibleHeightSpace +
              MediaQuery.of(context).size.height * .2 +
              .75,
      forceElevated: false,
    );
  }
}
