import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

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
  AsyncMemoizer<List<CentralizedExpressionResponse>> memoizer =
      AsyncMemoizer<List<CentralizedExpressionResponse>>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context);
  }

  Future<List<CentralizedExpressionResponse>> getExpressions() {
    return memoizer.runOnce(
        () => _userProvider.getUsersExpressions(widget.userProfile.address));
  }

  @override
  Widget build(BuildContext context) {
    // public expressions of user
    return FutureBuilder<dynamic>(
      future: getExpressions(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding:
                          const EdgeInsets.only(left: 10, right: 5, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          for (int index = 0;
                              index < snapshot.data.length + 1;
                              index++)
                            if (index == snapshot.data.length)
                              const SizedBox()
                            else if (index.isEven &&
                                snapshot.data[index].privacy == widget.privacy)
                              ExpressionPreview(
                                expression: snapshot.data[index],
                              )
                            else
                              const SizedBox()

                          // even number indexes
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding:
                          const EdgeInsets.only(left: 5, right: 10, top: 10),
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
                                snapshot.data[index].privacy == widget.privacy)
                              ExpressionPreview(
                                expression: snapshot.data[index],
                              )
                            else
                              const SizedBox()
                        ],
                      ),
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
