import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:provider/provider.dart';

// This component is used in CommentPreview
// as the 'more' icon is pressed to view the action items
class CommentActionItems extends StatelessWidget {
  const CommentActionItems({
    this.comment,
    this.userAddress,
    this.source,
  });

  final Comment comment;
  final String userAddress;
  final String source;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .36,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                userAddress == comment.creator.address
                    ? _myActionItems(context)
                    : _memberActionItems(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  // show these action items if the comment was created by user
  Widget _myActionItems(
    BuildContext context,
  ) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () async {
            // delete comment
            JuntoLoader.showLoader(context);
            try {
              await Provider.of<ExpressionRepo>(context, listen: false)
                  .deleteExpression(comment.address);

              JuntoLoader.hide();
              Navigator.pop(context);
              if (source == 'open') {
                Navigator.pop(context);
              }
            } catch (error) {
              print(error.message);
              Navigator.pop(context);
              JuntoLoader.hide();
              showDialog(
                context: context,
                builder: (BuildContext context) => const SingleActionDialog(
                  dialogText: 'Hmm, something went wrong.',
                ),
              );
            }
          },
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          title: Row(
            children: <Widget>[
              Text('Delete Comment',
                  style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ),
      ],
    );
  }

  // show these action items if the comment belongs to another user
  Widget _memberActionItems(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pop(context);
            // view den
            Navigator.push(
              context,
              CupertinoPageRoute<Widget>(
                builder: (BuildContext context) => JuntoMember(
                  profile: comment.creator,
                ),
              ),
            );
          },
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          title: Row(
            children: <Widget>[
              Text("View @${comment.creator.username}'s den",
                  style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ),
      ],
    );
  }
}
