import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class UserPreview extends StatelessWidget {
  const UserPreview({
    Key key,
    @required this.userProfile,
    @required this.onTap,
    this.isSelected,
    this.showSelectionIndicator = true,
  }) : super(key: key);

  final UserProfile userProfile;
  final ValueChanged<UserProfile> onTap;
  final bool isSelected;
  final bool showSelectionIndicator;

  Widget _handleNullImage(String imageUrl) {
    return Image.asset(
      'assets/images/junto-mobile__logo.png',
      height: 45.0,
      width: 45.0,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(userProfile);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            ClipOval(
              child: _handleNullImage(userProfile.profilePicture[0]),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width - 65,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(width: .5, color: JuntoPalette.juntoFade),
                  ),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${userProfile.name}',
                      textAlign: TextAlign.start,
                      style: JuntoStyles.title,
                    ),
                    Text(
                      '@${userProfile.username}',
                      textAlign: TextAlign.start,
                      style: JuntoStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            if (showSelectionIndicator)
              AnimatedContainer(
                duration: kThemeChangeDuration,
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? <Color>[
                            JuntoPalette.juntoSecondary,
                            JuntoPalette.juntoPrimary
                          ]
                        : <Color>[
                            Colors.white,
                            Colors.white,
                          ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  // color: widget.isSelected ? JuntoPalette.juntoPrimary : null,
                  border: Border.all(
                    color: isSelected ? Colors.white : const Color(0xffeeeeee),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              )
          ],
        ),
      ),
    );
  }
}
