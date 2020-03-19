import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AboutMember extends StatelessWidget {
  const AboutMember({this.profile});

  final UserData profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _aboutMemberAppbar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  if (profile.user.profilePicture.isNotEmpty)
                    _displayPhoto(context),
                  _displayName(context),
                  _displayAboutItem(
                    context,
                    profile.user.gender,
                    Icon(
                      CustomIcons.gender,
                      size: 17,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  _displayAboutItem(
                    context,
                    profile.user.location,
                    Image.asset(
                      'assets/images/junto-mobile__location.png',
                      height: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  _displayAboutItem(
                    context,
                    profile.user.website,
                    Image.asset(
                      'assets/images/junto-mobile__link.png',
                      height: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  _displayBio(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutMemberAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(45),
      child: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: 42,
                  height: 42,
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  child: Icon(
                    CustomIcons.back,
                    color: Theme.of(context).primaryColorDark,
                    size: 17,
                  ),
                ),
              ),
              Text(
                profile.user.username,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(width: 45),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(.75),
          child: Container(
            height: .75,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayPhoto(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: profile.user.profilePicture[0],
      width: MediaQuery.of(context).size.width,
      placeholder: (BuildContext context, String _) {
        return Container(
          color: Theme.of(context).dividerColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
        );
      },
      fit: BoxFit.cover,
    );
  }

  Widget _displayName(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        profile.user.name,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _displayBio(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        profile.user.bio,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _displayAboutItem(
      BuildContext context, List<String> item, dynamic icon) {
    if (item.isNotEmpty && item[0].isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            icon,
            const SizedBox(width: 5),
            Text(
              item[0],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
