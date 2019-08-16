import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

class ExpressionOpenBottomNav extends StatelessWidget {
  ExpressionOpenBottomNav(this.openComment);
  
  final VoidCallback openComment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xffeeeeee), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Icon(Icons.bookmark_border, size: 20),
          Icon(Icons.face, size: 20),
          Icon(CustomIcons.resonate, size: 20),
          GestureDetector(
            onTap: () {
              openComment();
            },
            child: Icon(
              CustomIcons.comment,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
