import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
    getCurrentTheme();
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

  String _getBackgroundImageAsset() {
    if (_currentTheme == 'rainbow' || _currentTheme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (_currentTheme == 'aqueous' || _currentTheme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (_currentTheme == 'royal' || _currentTheme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  Widget _displayRelationshipIndicator(BuildContext context) {
    if (widget.isFollowing == true && widget.isConnected == false) {
      return Icon(CustomIcons.groups,
          size: 17, color: Theme.of(context).primaryColor);
    } else if (widget.isFollowing == true && widget.isConnected == true) {
      return Icon(CustomIcons.pawprints,
          size: 17, color: Theme.of(context).primaryColor);
    } else if (widget.isFollowing == false && widget.isConnected == false) {
      return Image.asset('assets/images/junto-mobile__infinity.png',
          height: 14, color: Theme.of(context).primaryColor);
    } else {
      return Image.asset('assets/images/junto-mobile__infinity.png',
          height: 14, color: Theme.of(context).primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Brightness.light,
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
      backgroundColor: Theme.of(context).colorScheme.background,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      _getBackgroundImageAsset(),
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    key: _keyFlexibleSpace,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.profile.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              widget.toggleMemberRelationships();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 14),
                                  _displayRelationshipIndicator(context),
                                  const SizedBox(width: 2),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 12,
                                      color: Theme.of(context).primaryColor)
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .2 - 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MemberAvatar(
                  diameter: 60,
                  profilePicture: widget.profile.profilePicture,
                ),
              ),
            ),
          ],
        ),
      ),
      expandedHeight: _flexibleHeightSpace == null
          ? 1000
          : _flexibleHeightSpace + MediaQuery.of(context).size.height * .2,
      forceElevated: false,
    );
  }
}
