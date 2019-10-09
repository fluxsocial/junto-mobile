import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/widgets/comment_preview/comment_action_items.dart';

/// Shows a preview of the comments. Takes a un-named [String] as a param.
class CommentPreview extends StatelessWidget {
  const CommentPreview({
    Key key,
    @required this.commentText,
  }) : super(key: key);

  /// String to be displayed as comment
  final String commentText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: JuntoStyles.horizontalPadding,
          right: JuntoStyles.horizontalPadding,
          top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (BuildContext context) => JuntoMember(
                    profile: UserProfile(
                      address: '',
                      firstName: 'Eric',
                      lastName: 'Yang',
                      bio: 'This is a test',
                      profilePicture: 'assets/images/junto-mobile__logo.png',
                      username: 'Gmail',
                      verified: false,
                    ),
                  ),
                ),
              );
            },
            child: ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__eric.png',
                height: 36.0,
                width: 36.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .5,
                ),
              ),
            ),
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 66,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<dynamic>(
                              builder: (BuildContext context) => JuntoMember(
                                profile: UserProfile(
                                  address: '',
                                  firstName: 'Eric',
                                  lastName: 'Yang',
                                  bio: 'This is a test',
                                  profilePicture:
                                      'assets/images/junto-mobile__logo.png',
                                  username: 'Gmail',
                                  verified: false,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text(
                                'Eric Yang',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('sunyata'),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            CommentActionItems()
                                .buildCommentActionItems(context);
                          },
                          child: const Icon(CustomIcons.more, size: 20))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  width: MediaQuery.of(context).size.width - 66,
                  child: Text(
                    commentText,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                    '5m',
                    style:
                        TextStyle(fontSize: 10, color: JuntoPalette.juntoSleek),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
