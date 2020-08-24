import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/backend/user_data_provider.dart';
import 'package:provider/provider.dart';

class FilterColumnWidget extends StatelessWidget {
  const FilterColumnWidget({this.twoColumnView});

  final bool twoColumnView;

  Future<void> switchColumnView(
      BuildContext context, ExpressionFeedLayout columnType) async {
    await Provider.of<UserDataProvider>(context, listen: false)
        .switchColumnLayout(columnType);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => switchColumnView(context, ExpressionFeedLayout.two),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Icon(
              CustomIcons.twocolumn,
              size: 20,
              color: twoColumnView
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColorLight,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => switchColumnView(context, ExpressionFeedLayout.single),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 10,
            ),
            child: Icon(
              CustomIcons.singlecolumn,
              size: 20,
              color: twoColumnView
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
