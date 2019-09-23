import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

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
            padding: const EdgeInsets.symmetric(
                horizontal: JuntoStyles.horizontalPadding, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
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
