import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:provider/provider.dart';

class CollectivePopulatedList extends StatelessWidget {
  const CollectivePopulatedList(
    this.state, {
    Key key,
  }) : super(key: key);

  final CollectivePopulated state;

  @override
  Widget build(BuildContext context) {
    if (state.results.length == 0) {
      // TODO:ERIC -- return empty state placeholder here
      return SliverToBoxAdapter(
        child: const SizedBox(),
      );
    } else {
      return Consumer<UserDataProvider>(
        builder: (context, snapshot, _) {
          if (snapshot.twoColumnView) {
            return TwoColumnList(
              data: state.results,
              useSliver: true,
            );
          }
          return SingleColumnSliverListView(
            key: ValueKey<String>('single-column'),
            data: state.results,
            privacyLayer: 'Public',
          );
        },
      );
    }
  }
}
