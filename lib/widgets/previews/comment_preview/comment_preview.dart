import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/widgets/previews/comment_preview/comment_action_items.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // comment preview top
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
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
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            height: 38.0,
                            width: 38.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          child: const Text(
                            'sunyata',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => Container(
                        color: const Color(0xff737373),
                        child: CommentActionItems(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Color(0xff555555),
                  ),
                ),
              ],
            ),
          ),
          // comment preview body
          Container(
            child: Text(
              commentText,
              style: const TextStyle(
                  fontSize: 15, height: 1.4, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '5m',
            style: TextStyle(fontSize: 10, color: JuntoPalette.juntoSleek),
          ),
        ],
      ),
    );
  }
}
