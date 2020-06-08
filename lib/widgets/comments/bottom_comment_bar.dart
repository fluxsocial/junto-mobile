import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:provider/provider.dart';

class BottomCommentBar extends StatefulWidget {
  const BottomCommentBar({
    Key key,
    @required this.expressionAddress,
    @required this.refreshComments,
    @required this.openComments,
    @required this.scrollToBottom,
  }) : super(key: key);
  final String expressionAddress;
  final Function refreshComments;
  final Function openComments;
  final Function scrollToBottom;

  @override
  BottomCommentBarState createState() => BottomCommentBarState();
}

enum MessageType { regular, gif }

class BottomCommentBarState extends State<BottomCommentBar> {
  String selectedUrl;
  TextEditingController commentController;

  Future<void> _createComment() async {
    if (commentController.value.text != '') {
      JuntoLoader.showLoader(context);
      try {
        await Provider.of<ExpressionRepo>(context, listen: false)
            .postCommentExpression(
          widget.expressionAddress,
          'LongForm',
          LongFormExpression(
            title: 'Expression Comment',
            body: commentController.value.text.trim(),
          ).toMap(),
        );
        commentController.clear();
        JuntoLoader.hide();
        // _focusNode.unfocus();
        await showFeedback(
          context,
          icon: Icon(
            CustomIcons.newcreate,
            size: 33,
            color: Theme.of(context).primaryColor,
          ),
          message: 'Comment Created',
        );
        await widget.refreshComments();
        await widget.openComments();
        await Future.delayed(Duration(milliseconds: 100));
        widget.scrollToBottom();
      } catch (error) {
        debugPrint('Error posting comment $error');
        JuntoLoader.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) => const SingleActionDialog(
            dialogText: 'Hmm, something went wrong.',
          ),
        );
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 15.0,
          bottom: 15.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: .5,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(25),
                ),
                constraints: const BoxConstraints(maxHeight: 180),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        // focusNode: widget.focusNode,
                        controller: commentController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write a reply...',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        maxLines: null,
                        cursorColor: Theme.of(context).primaryColor,
                        cursorWidth: 2,
                        style: Theme.of(context).textTheme.caption,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardAppearance: Theme.of(context).brightness,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _createComment,
              child: Icon(
                Icons.send,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
