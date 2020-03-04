import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context);
  }

  Future<List<ExpressionResponse>> getExpressions() {
    return memoizer.runOnce(
        () => _userProvider.getUsersExpressions(widget.userProfile.address));
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset('assets/images/junto-mobile__filter.png',
                              height: 17),
                          Row(
                            children: <Widget>[
                              Icon(CustomIcons.twocolumn, size: 20),
                              const SizedBox(width: 10),
                              Icon(CustomIcons.singlecolumn, size: 20),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .5,
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              for (int index = 0;
                                  index < snapshot.data.length + 1;
                                  index++)
                                if (index == snapshot.data.length)
                                  const SizedBox()
                                else if (index.isEven &&
                                    snapshot.data[index].privacy ==
                                        widget.privacy)
                                  TwoColumnExpressionPreview(
                                    expression: snapshot.data[index],
                                    userAddress: widget.userProfile.address,
                                  )
                                else
                                  const SizedBox()

                              // even number indexes
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .5,
                          padding: const EdgeInsets.only(
                              left: 5, right: 10, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // odd number indexes
                              for (int index = 0;
                                  index < snapshot.data.length + 1;
                                  index++)
                                if (index == snapshot.data.length)
                                  const SizedBox()
                                else if (index.isOdd &&
                                    snapshot.data[index].privacy ==
                                        widget.privacy)
                                  TwoColumnExpressionPreview(
                                    expression: snapshot.data[index],
                                    userAddress: widget.userProfile.address,
                                  )
                                else
                                  const SizedBox()
                            ],
                          ),
                        ),
                      ],
                    ),
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
