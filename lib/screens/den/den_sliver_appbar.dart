import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/den/edit_den.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/profile_picture_avatar.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_item.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/bio.dart';

class JuntoDenSliverAppbar extends StatefulWidget {
  const JuntoDenSliverAppbar(
      {Key key, @required this.profile, @required this.currentTheme})
      : super(key: key);

  final UserData profile;
  final String currentTheme;

  @override
  State<StatefulWidget> createState() {
    return JuntoDenSliverAppbarState();
  }
}

class JuntoDenSliverAppbarState extends State<JuntoDenSliverAppbar> {
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

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  String _getBackgroundImageAsset() {
    if (widget.currentTheme == 'rainbow' ||
        widget.currentTheme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (widget.currentTheme == 'aqueous' ||
        widget.currentTheme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (widget.currentTheme == 'royal' ||
        widget.currentTheme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  Widget _editDen() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => JuntoEditDen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: Text(
          'Edit Den',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Brightness.light,
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
      backgroundColor: Colors.white,
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
                      horizontal: 10,
                      vertical: 15,
                    ),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.profile.user.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            _editDen(),
                          ],
                        ),
                        if (widget.profile.user.gender.isNotEmpty ||
                            widget.profile.user.location.isNotEmpty ||
                            widget.profile.user.website.isNotEmpty)
                          const SizedBox(height: 15),
                        AboutItem(
                          item: widget.profile.user.gender,
                          icon: Icon(CustomIcons.gender,
                              size: 17, color: Theme.of(context).primaryColor),
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
                          icon: Image.asset(
                            'assets/images/junto-mobile__link.png',
                            height: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (widget.profile.user.bio != '' &&
                            widget.profile.user.bio != null &&
                            widget.profile.user.bio != ' ')
                          MemberBio(profile: widget.profile)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MemberProfilePictureAvatar(profile: widget.profile),
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
