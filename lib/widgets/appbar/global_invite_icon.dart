import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GlobalInviteIcon extends StatelessWidget {
  const GlobalInviteIcon({this.community});

  final dynamic community;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => GlobalInviteDialog(
            context: context,
          ),
        );
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Icon(
          Icons.mail_outline,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
    );
  }
}

class GlobalInviteDialog extends StatelessWidget {
  const GlobalInviteDialog({
    this.context,
  });

  final BuildContext context;

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
              "Feel free to share this link to our private beta with friends you'd like to invite to your communities!",
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
                  "https://junto.typeform.com/to/k7BUVK8f",
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
