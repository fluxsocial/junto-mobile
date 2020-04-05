import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
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
    final media = MediaQuery.of(context);
    if (state.results.length == 0) {
      return SliverToBoxAdapter(
        child: const SizedBox(),
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
            Padding(
              padding: EdgeInsets.only(
                bottom: media.padding.bottom + 60.0,
                top: 12.0,
              ),
              child: FlatButton.icon(
                onPressed: () {
                  context.bloc<CollectiveBloc>().add(FetchMoreCollective());
                },
                icon: Icon(CustomIcons.lotus),
                label: Text('More'),
              ),
            ),
          ],
        ),
      );
    }
  }
}
