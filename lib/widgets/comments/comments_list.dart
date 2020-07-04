import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/comment_preview/comment_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    this.commentsVisible,
    this.expression,
    this.futureComments,
    this.showComments,
  });

  final bool commentsVisible;
  final dynamic expression;

  final Future<QueryResults<Comment>> futureComments;
  final Function showComments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResults<Comment>>(
      future: futureComments,
      builder: (
        BuildContext context,
        AsyncSnapshot<QueryResults<Comment>> snapshot,
      ) {
        if (snapshot.hasError) {
          return Container(
            child: const Text('Hmm, something went wrong'),
          );
        }

        if (snapshot.hasData) {
          if (snapshot.data.results.isNotEmpty) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: showComments,
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(
                      bottom: commentsVisible ? 0 : 15,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          commentsVisible
                              ? 'Hide replies'
                              : 'Show replies (${snapshot.data.results.length})',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 5),
                        if (!commentsVisible)
                          Icon(Icons.keyboard_arrow_down,
                              size: 15,
                              color: Theme.of(context).primaryColorLight),
                        if (commentsVisible)
                          Icon(Icons.keyboard_arrow_up,
                              size: 15,
                              color: Theme.of(context).primaryColorLight),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: commentsVisible,
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentPreview(
                        comment: snapshot.data.results[index],
                        parent: expression,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox(height: 25);
          }
        }
        return Transform.translate(
          offset: const Offset(0.0, 50.0),
          child: JuntoProgressIndicator(),
        );
      },
    );
  }
}
