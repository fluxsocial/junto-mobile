import 'package:flutter/material.dart';

class ExpressionOpenShowReplies extends StatelessWidget {
  const ExpressionOpenShowReplies({
    Key key,
    @required this.toggleReplies,
    @required this.showRepliesText,
  }) : super(key: key);

  final VoidCallback toggleReplies;
  final Widget showRepliesText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffeeeeee),
                  width: .5,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                toggleReplies();
              },
              child: showRepliesText,
            ),
          ),
        ],
      ),
    );
  }
}
