import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';

/// Linear list of expressions created by the given [userProfile].
class UserExpressions extends StatefulWidget {
  const UserExpressions({
    Key key,
    @required this.userProfile,
    @required this.privacy,
  }) : super(key: key);

  /// [UserProfile] of the user
  final UserProfile userProfile;

  /// Either Public or Private;
  final String privacy;

  @override
  _UserExpressionsState createState() => _UserExpressionsState();
}

class _UserExpressionsState extends State<UserExpressions> {
  UserRepo _userProvider;
  AsyncMemoizer<List<ExpressionResponse>> memoizer =
      AsyncMemoizer<List<ExpressionResponse>>();

  bool twoColumnView = true;

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getBool('two-column-view') != null) {
        twoColumnView = prefs.getBool('two-column-view');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context);
  }

  Future<List<ExpressionResponse>> getExpressions() {
    return memoizer.runOnce(
        () => _userProvider.getUsersExpressions(widget.userProfile.address));
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

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    // public expressions of user
    return FutureBuilder<List<ExpressionResponse>>(
      future: getExpressions(),
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
                          duration: const Duration(milliseconds: 200),
                          firstChild: TwoColumnListView(
                            userAddress: widget.userProfile.address,
                            data: snapshot.data,
                            privacyLayer: 'Public',
                          ),
                          secondChild: SingleColumnListView(
                            userAddress: widget.userProfile.address,
                            data: snapshot.data,
                            privacyLayer: 'Public',
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
