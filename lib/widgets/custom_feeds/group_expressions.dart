import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

/// Linear list of expressions created by the given [userProfile].
class GroupExpressions extends StatefulWidget {
  const GroupExpressions(
      {Key key,
      @required this.group,
      @required this.userAddress,
      @required this.expressionsPrivacy})
      : super(key: key);

  /// Group
  final Group group;
  final String userAddress;
  final String expressionsPrivacy;

  @override
  _GroupExpressionsState createState() => _GroupExpressionsState();
}

class _GroupExpressionsState extends State<GroupExpressions> {
  bool twoColumnView = true;

  final AsyncMemoizer<QueryResults<ExpressionResponse>> _memoizer =
      AsyncMemoizer<QueryResults<ExpressionResponse>>();

  Future<QueryResults<ExpressionResponse>> _getGroupExpressions() async {
    final Map<String, String> _params = <String, String>{
      'context': widget.group.address,
      'context_type': 'Group',
      'pagination_position': '0',
    };
    return _memoizer.runOnce(
      () => Provider.of<ExpressionRepo>(context, listen: false)
          .getCollectiveExpressions(_params),
    );
  }

  void _switchColumnView(String columnType) {
    setState(() {
      if (columnType == 'two') {
        twoColumnView = true;
      } else if (columnType == 'single') {
        twoColumnView = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // public expressions of user
    return FutureBuilder<QueryResults<ExpressionResponse>>(
      future: _getGroupExpressions(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QueryResults<ExpressionResponse>> snapshot,
      ) {
        if (snapshot.hasError) {
          return Center(
            child: Transform.translate(
              offset: const Offset(
                0.0,
                -50,
              ),
              child: const Text(
                'Hmm, something is up with our server',
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (snapshot.data.results.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__filter.png',
                              height: 17,
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _switchColumnView('two'),
                                  child: Container(
                                    child: Icon(
                                      CustomIcons.twocolumn,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _switchColumnView('single');
                                  },
                                  child: Container(
                                    child: Icon(
                                      CustomIcons.singlecolumn,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    Container(
                        color: Theme.of(context).colorScheme.background,
                        child: AnimatedCrossFade(
                          crossFadeState: twoColumnView
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(
                            milliseconds: 200,
                          ),
                          firstChild: TwoColumnListView(
                            userAddress: widget.userAddress,
                            data: snapshot.data.results,
                            privacyLayer: widget.expressionsPrivacy,
                            showComments: false,
                          ),
                          secondChild: SingleColumnListView(
                            userAddress: widget.userAddress,
                            data: snapshot.data.results,
                            privacyLayer: widget.expressionsPrivacy,
                            showComments: false,
                          ),
                        )),
                  ],
                )
              ],
            ),
          );
        }
        return Center(
          child: Transform.translate(
            offset: const Offset(0.0, -50),
            child: JuntoProgressIndicator(),
          ),
        );
      },
    );
  }
}
