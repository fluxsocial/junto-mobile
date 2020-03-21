import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/get_more_expressions_button.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
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
        //TODO(Nash): Add illustration for error state.
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: Text('No expressions'),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 1000),
              curve: Curves.ease,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, anim, child) {
                return Opacity(
                  opacity: anim,
                  child: child,
                );
              },
              child: Consumer<UserDataProvider>(
                builder: (context, user, _) => AnimatedCrossFade(
                  crossFadeState: user.twoColumnView
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                  firstCurve: Curves.easeInOut,
                  firstChild: TwoColumnSliverListView(
                    data: state.results,
                  ),
                  secondChild: SingleColumnSliverListView(
                    data: state.results,
                    privacyLayer: 'Public',
                  ),
                ),
              ),
            ),
            const GetMoreExpressionsButton(),
          ],
        ),
      );
    }
  }
}
