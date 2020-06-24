import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class JuntoCommunityCenterFeedback extends StatelessWidget {
  final String communityCenterAddress = '48b97134-1a4d-deb0-b27c-9bcdfc33f386';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
              return Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: snapshot.data.results
                      .map(
                        (dynamic expression) => SingleColumnExpressionPreview(
                          expression: expression,
                        ),
                      )
                      .toList(),
                ),
              );
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
  }
}
