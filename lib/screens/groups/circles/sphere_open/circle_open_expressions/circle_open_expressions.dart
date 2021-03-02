import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';

class CircleOpenExpressions extends StatelessWidget {
  CircleOpenExpressions({this.getExpressions, this.deleteExpression});
  final Future<QueryResults<ExpressionResponse>> getExpressions;
  final Function deleteExpression;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppRepo>(builder: (context, AppRepo appRepo, _) {
      return FutureBuilder<QueryResults<ExpressionResponse>>(
        future: getExpressions,
        builder: (BuildContext context,
            AsyncSnapshot<QueryResults<ExpressionResponse>> snapshot) {
          if (snapshot.hasData && snapshot.data.results.length == 0) {
            return FeedPlaceholder(
              placeholderText: 'No expressions yet!',
              image: 'assets/images/junto-mobile__placeholder--feed.png',
            );
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                FilterColumnRow(
                  twoColumnView: Provider.of<AppRepo>(context, listen: false)
                      .twoColumnLayout,
                ),
                appRepo.twoColumnLayout
                    ? Expanded(
                        child: TwoColumnList(
                          data: snapshot.data.results,
                          deleteExpression: deleteExpression,
                        ),
                      )
                    : Expanded(
                        child: SingleColumnListView(
                          data: snapshot.data.results,
                          privacyLayer: 'Public',
                          deleteExpression: deleteExpression,
                        ),
                      ),
              ],
            );
          } else if (snapshot.hasError) {
            return JuntoErrorWidget(
              errorMessage: 'Hmm, something went wrong',
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0.0, -50),
              child: JuntoProgressIndicator(),
            ),
          );
        },
      );
    });
  }
}
