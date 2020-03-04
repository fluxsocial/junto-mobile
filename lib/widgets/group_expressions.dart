import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/custom_listview.dart';

/// Linear list of expressions created by the given [userProfile].
class GroupExpressions extends StatefulWidget {
  const GroupExpressions({
    Key key,
    @required this.group,
    @required this.userAddress,
  }) : super(key: key);

  /// Group
  final Group group;
  final String userAddress;

  @override
  _GroupExpressionsState createState() => _GroupExpressionsState();
}

class _GroupExpressionsState extends State<GroupExpressions> {
  bool twoColumnView = true;

  final AsyncMemoizer<List<ExpressionResponse>> _memoizer =
      AsyncMemoizer<List<ExpressionResponse>>();

  Future<List<ExpressionResponse>> _getGroupExpressions() async {
    return _memoizer.runOnce(
      () => Provider.of<GroupRepo>(context, listen: false).getGroupExpressions(
        widget.group.address,
        GroupExpressionQueryParams(
            creatorExpressions: true,
            directExpressions: true,
            directExpressionPaginationPosition: 0,
            creatorExpressionsPaginationPosition: 0),
      ),
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
    return FutureBuilder<List<ExpressionResponse>>(
      future: _getGroupExpressions(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ExpressionResponse>> snapshot,
      ) {
        if (snapshot.hasError) {
          return Center(
            child: Transform.translate(
              offset: const Offset(0.0, -50),
              child: const Text('Hmm, something is up with our server'),
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
                    if (snapshot.data.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                                'assets/images/junto-mobile__filter.png',
                                height: 17),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _switchColumnView('two'),
                                  child: Container(
                                    child:
                                        Icon(CustomIcons.twocolumn, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    _switchColumnView('single');
                                  },
                                  child: Container(
                                    child: Icon(CustomIcons.singlecolumn,
                                        size: 20),
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
                          duration: const Duration(milliseconds: 200),
                          firstChild: TwoColumnListView(
                            userAddress: widget.userAddress,
                            data: snapshot.data,
                            privacyLayer: 'Public',
                            showComments: false,
                          ),
                          secondChild: SingleColumnListView(
                            userAddress: widget.userAddress,
                            data: snapshot.data,
                            privacyLayer: 'Public',
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
