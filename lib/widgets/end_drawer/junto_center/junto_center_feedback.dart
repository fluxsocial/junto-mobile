import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';

class JuntoCommunityCenterFeedback extends StatelessWidget {
  final String communityCenterAddress = '48b97134-1a4d-deb0-b27c-9bcdfc33f386';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppRepo>(builder: (context, AppRepo appRepo, _) {
      return Column(
        children: <Widget>[
          FilterColumnRow(
            twoColumnView: appRepo.twoColumnLayout,
          ),
          FutureBuilder<QueryResults<ExpressionResponse>>(
            future: Provider.of<ExpressionRepo>(context, listen: false)
                .getCollectiveExpressions(
              {
                'context': '48b97134-1a4d-deb0-b27c-9bcdfc33f386',
                'context_type': 'Group',
                'pagination_position': '0',
              },
            ),
            builder: (BuildContext context,
                AsyncSnapshot<QueryResults<ExpressionResponse>> snapshot) {
              if (snapshot.hasData) {
                if (appRepo.twoColumnLayout) {
                  return Expanded(
                    child: TwoColumnList(
                      data: snapshot.data.results,
                    ),
                  );
                } else {
                  return Expanded(
                    child: SingleColumnListView(
                      data: snapshot.data.results,
                      privacyLayer: 'Public',
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return JuntoErrorWidget(
                  errorMessage: 'Hmm, something went wrong',
                );
              }
              return Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0.0, -50),
                    child: JuntoProgressIndicator(),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
