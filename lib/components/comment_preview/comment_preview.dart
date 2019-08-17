import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

/// Shows a preview of the comments. Takes a un-named [String] as a param.
class CommentPreview extends StatelessWidget {
  const CommentPreview(this.commentText);

  /// String to be displayed as comment
  final String commentText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/images/junto-mobile__eric.png',
              height: 36.0,
              width: 36.0,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xffeeeeee),
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
                      Row(
                        children: <Widget>[
                          Text(
                            'Eric Yang',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text('sunyata'),
                        ],
                      ),
                      Icon(CustomIcons.more, size: 20)
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
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  child: Text(
                    '5 MINUTES AGO',
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color(
                        0xff555555,
                      ),
                    ),
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
