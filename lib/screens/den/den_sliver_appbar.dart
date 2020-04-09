import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_button.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_item.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_photo.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_placeholder.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/bio.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/profile_picture_avatar.dart';
import 'package:provider/provider.dart';

class JuntoDenSliverAppbar extends StatefulWidget {
  const JuntoDenSliverAppbar({Key key, @required this.profile})
      : super(key: key);

  final UserData profile;

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
    final double heightFlexibleSpace = sizeFlexibleSpace.shortestSide;
    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.profile.user.backgroundPhoto;
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
              key: _keyFlexibleSpace,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (photo != null && (photo.isNotEmpty || photo != ''))
                    MemberBackgroundPhoto(profile: widget.profile),
                  if (photo == null || photo.isEmpty)
                    Consumer<JuntoThemesProvider>(
                      builder: (_, theme, __) =>
                          MemberBackgroundPlaceholder(theme: theme.themeName),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      top: 45.0,
                      bottom: 15,
                    ),
                    child: Row(
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
                        Consumer<JuntoThemesProvider>(
                          builder: (_, theme, __) =>
                              EditDenButton(currentTheme: theme.themeName),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: _DenUserInfo(
                      profile: widget.profile,
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
          : _flexibleHeightSpace + MediaQuery.of(context).size.shortestSide / 8,
    );
  }
}

class _DenUserInfo extends StatelessWidget {
  const _DenUserInfo({Key key, this.profile}) : super(key: key);
  final UserData profile;

  UserProfile get user => profile.user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (user.gender.isNotEmpty ||
            user.location.isNotEmpty ||
            user.website.isNotEmpty)
          const SizedBox(height: 15),
        AboutItem(
          item: user.gender,
          icon: Icon(
            CustomIcons.gender,
            size: 17,
            color: Theme.of(context).primaryColor,
          ),
        ),
        AboutItem(
          item: user.location,
          icon: Image.asset(
            'assets/images/junto-mobile__location.png',
            height: 15,
            color: Theme.of(context).primaryColor,
          ),
        ),
        AboutItem(
          item: user.website,
          isWebsite: true,
          icon: Image.asset(
            'assets/images/junto-mobile__link.png',
            height: 15,
            color: Theme.of(context).primaryColor,
          ),
        ),
        MemberBio(profile: profile)
      ],
    );
  }
}
