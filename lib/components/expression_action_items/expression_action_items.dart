import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class ExpressionActionItems {
  void buildExpressionActionItems(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text('Report Expression'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text(
                'Hide Expression',
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text('Block @randomuser'),
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
