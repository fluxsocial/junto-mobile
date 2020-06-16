import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/feed_placeholder.dart';
import 'package:provider/provider.dart';

class CollectivePopulatedList extends StatelessWidget {
  const CollectivePopulatedList(
    this.state, {
    Key key,
    @required this.deleteExpression,
  }) : super(key: key);

  final CollectivePopulated state;
  final ValueChanged<ExpressionResponse> deleteExpression;

  String _placeholderText() {
    if (state.name == 'Subscriptions') {
      return 'No expressions yet. Start subscribing people you want to hear from!';
    } else if (state.name == 'Connections') {
      return 'No expressions yet. Start connecting with people you want to hear from!';
    } else {
      return 'No expressions yet. Start customizing and adding people to your perspectives!';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state.results.length == 0) {
      return SliverToBoxAdapter(
        child: FeedPlaceholder(
          placeholderText: _placeholderText(),
        ),
      );
    } else {
      return Consumer<AppRepo>(
        builder: (context, snapshot, _) {
          if (snapshot.twoColumnLayout) {
            return TwoColumnList(
              data: state.results,
              useSliver: true,
              deleteExpression: deleteExpression,
            );
          }
          return SingleColumnSliverListView(
            key: ValueKey<String>('single-column'),
            data: state.results,
            privacyLayer: 'Public',
            deleteExpression: deleteExpression,
          );
        },
      );
    }
  }
}
