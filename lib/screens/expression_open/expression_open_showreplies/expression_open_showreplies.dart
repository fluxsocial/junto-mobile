import 'package:flutter/material.dart';

class ExpressionOpenShowReplies extends StatelessWidget {
  Function toggleReplies;
  Widget showRepliesText;

  ExpressionOpenShowReplies(this.toggleReplies, this.showRepliesText);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
            )),
            child: GestureDetector(
                onTap: () {
                  toggleReplies();
                },
                child: showRepliesText)),
      ],
    ));
  }
}
