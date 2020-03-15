import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Linear list of expressions created by the given [userProfile].
class GroupExpressions extends StatefulWidget {
  const GroupExpressions({
    Key key,
    @required this.group,
    @required this.userAddress,
    @required this.expressionsPrivacy,
    @required this.shouldRefresh,
  }) : super(key: key);

  /// Group
  final Group group;
  final String userAddress;
  final String expressionsPrivacy;
  final ValueNotifier<bool> shouldRefresh;

  @override
  _GroupExpressionsState createState() => _GroupExpressionsState();
}

class _GroupExpressionsState extends State<GroupExpressions> {
  bool twoColumnView = true;

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  /// Fetches the pack's expression and aches the result
  Future<QueryResults<ExpressionResponse>> _getGroupExpressions() async {
    if (widget.shouldRefresh.value) {
      final Map<String, String> _params = <String, String>{
        'context': widget.group.address,
        'context_type': 'Group',
        'pagination_position': '0',
      };
      widget.shouldRefresh.value = false;
      final QueryResults<ExpressionResponse> results =
          await Provider.of<ExpressionRepo>(
        context,
        listen: false,
      ).getPackExpressions(
        _params,
      );
      // Rebuild UI with results
      setState(() {});
      return results;
    } else {
      return Provider.of<ExpressionRepo>(context).cachedResults;
    }
  }

  Future<void> _onRefresh() async {
    widget.shouldRefresh.value = true;
    _getGroupExpressions();
  }

  Future<void> _switchColumnView(String columnType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (columnType == 'two') {
        twoColumnView = true;
        prefs.setBool('two-column-view', true);
      } else if (columnType == 'single') {
        twoColumnView = false;
        prefs.setBool('two-column-view', false);
      }
    });
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        if (prefs.getBool('two-column-view') != null) {
          twoColumnView = prefs.getBool('two-column-view');
        }
      });
  }

  @override
  Widget build(BuildContext context) {
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
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (snapshot.data.results.isNotEmpty &&
                          snapshot.data.results[0].privacy ==
                              widget.expressionsPrivacy)
                        FilterColumnRow(
                          twoColumnView: twoColumnView,
                          switchColumnView: _switchColumnView,
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
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return Center(
          child: JuntoProgressIndicator(),
        );
      },
    );
  }
}
