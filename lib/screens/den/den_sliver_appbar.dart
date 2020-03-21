import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_button.dart';
import 'package:junto_beta_mobile/screens/den/den_background_photo.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/profile_picture_avatar.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_item.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/bio.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_placeholder.dart';

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

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
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
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.profile.user.backgroundPhoto.isNotEmpty ||
                          widget.profile.user.backgroundPhoto != ''
                      ? DenBackgroundPhoto(profile: widget.profile)
                      : MemberBackgroundPlaceholder(theme: widget.currentTheme),
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
                            EditDenButton(currentTheme: widget.currentTheme),
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
                ],
              ),
            ),
            MemberProfilePictureAvatar(profile: widget.profile),
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
