import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This component is used in CommentPreview
// as the 'more' icon is pressed to view the action items
class CommentActionItems {
  void buildCommentActionItems(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text('Report Comment'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text(
                'Hide Comment',
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
