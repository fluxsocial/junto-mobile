import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items.dart';

class ExpressionPreviewTop extends StatelessWidget {
  const ExpressionPreviewTop({
    Key key,
    this.expression,
  }) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    //ignore: unused_local_variable
    final String name = expression.creator.name;
    final String username = expression.creator.username;
    final String profilePicture = expression.creator.profilePicture;

    return Container(
      padding: const EdgeInsets.only(
          // top: 10,
          // bottom: 10,
          // left: 10,
          // right: 10
          ),
      // padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (
                    BuildContext context,
                  ) =>
                      JuntoMember(
                    profile: UserProfile(
                      address: '',
                      name: name,
                      bio: 'This is a test',
                      profilePicture: profilePicture,
                      username: username,
                      verified: false,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // // profile picture
                  // ClipOval(
                  //   child: Image.asset(
                  //     profilePicture.isEmpty
                  //         ? 'assets/images/junto-mobile__junto.png'
                  //         : profilePicture,
                  //     height: 28.0,
                  //     width: 28.0,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // const SizedBox(width: 5),
                  Container(
                    child: Text(
                      username.toLowerCase(),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
          // Row(
          //   children: <Widget>[
          //     GestureDetector(
          //       onTap: () {
          //         showModalBottomSheet(
          //           context: context,
          //           builder: (BuildContext context) => Container(
          //               color: Colors.transparent,
          //               child: ExpressionActionItems()),
          //         );
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.all(5),
          //         color: Colors.transparent,
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: Theme.of(context).primaryColorLight,
          //           size: 24,
          //         ),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
