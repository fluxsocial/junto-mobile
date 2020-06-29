import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/appbar/filter_drawer_button.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/backend/user_data_provider.dart';
import 'package:provider/provider.dart';

class FilterColumnRow extends StatelessWidget {
  const FilterColumnRow({this.twoColumnView});

  final bool twoColumnView;

  Future<void> switchColumnView(
      BuildContext context, ExpressionFeedLayout columnType) async {
    await Provider.of<UserDataProvider>(context, listen: false)
        .switchColumnLayout(columnType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //todo: add some animation/splash
          const FilterDrawerButton(),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () =>
                    switchColumnView(context, ExpressionFeedLayout.two),
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
                onTap: () =>
                    switchColumnView(context, ExpressionFeedLayout.single),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
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
          )
        ],
      ),
    );
  }
}
