import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
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
      return SliverToBoxAdapter(
        child: const SizedBox(),
      );
    } else {
      return Consumer<UserDataProvider>(builder: (context, snapshot, _) {
        return SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              AnimatedSwitcher(
                duration: kThemeChangeDuration,
                child: snapshot.twoColumnView
                    ? TwoColumnList(data: state.results)
                    : SingleColumnSliverListView(
                        key: ValueKey<String>('single-column'),
                        data: state.results,
                        privacyLayer: 'Public',
                      ),
              ),
              if (state.availableMore == true && state.loadingMore != true)
                FetchMoreButton(
                  onPressed: () => context.bloc<CollectiveBloc>().add(
                        FetchMoreCollective(),
                      ),
                ),
            ],
          ),
        );
      });
    }
  }
}
