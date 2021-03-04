import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:share/share.dart';

class JuntoInviteAppBar extends StatelessWidget {
  final UserData userProfile;

  const JuntoInviteAppBar({Key key, this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      elevation: 0,
      titleSpacing: 0,
      brightness: Theme.of(context).brightness,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
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
              'Invite',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => JuntoBetaInviteDialog(
                    context: context,
                    userProfile: userProfile,
                  ),
                );
                // Share.share(
                //   "Hey! I started using this more authentic and nonprofit social media platform called Junto. Here's an invite to their closed alpha - you can connect with me @${userProfile.user.username}. https://junto.typeform.com/to/k7BUVK8f",
                //   subject: 'Check Junto out!',
                // );
              },
              child: Container(
                width: 42,
                child: Image.asset(
                  'assets/images/junto-mobile__external-link.png',
                  height: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
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
    );
  }
}

class JuntoBetaInviteDialog extends StatelessWidget {
  const JuntoBetaInviteDialog({
    this.context,
    this.userProfile,
  });

  final BuildContext context;
  final UserData userProfile;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Feel free to share our Indiegogo campaign with your friends! Those who contribute will get instant access to our private beta. ',
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                Share.share(
                  "https://www.indiegogo.com/projects/junto-a-new-breed-of-social-media--2#/",
                  subject: 'Check out the Junto beta!',
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/junto-mobile__external-link.png',
                      height: 17,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Copy Link',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(right: 25, left: 25, bottom: 25),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
