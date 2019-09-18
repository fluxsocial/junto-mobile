import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class MemberActionItems {
  void buildMemberActionItems(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text('Block member'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
