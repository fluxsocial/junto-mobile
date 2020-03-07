import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context);
  }

  Future<List<ExpressionResponse>> getExpressions() {
    return memoizer.runOnce(
        () => _userProvider.getUsersExpressions(widget.userProfile.address));
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
                                        child: Icon(CustomIcons.twocolumn,
                                            size: 20))),
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
                            userAddress: widget.userProfile.address,
                            data: snapshot.data,
                            privacyLayer: 'Public',
                            showComments: false,
                          ),
                          secondChild: SingleColumnListView(
                            userAddress: widget.userProfile.address,
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
