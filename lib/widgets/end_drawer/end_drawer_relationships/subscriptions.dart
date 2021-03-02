import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/relations_bloc/relation_bloc.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

import './search_bar.dart';

class Subscriptions extends StatefulWidget {
  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    context
        .bloc<RelationBloc>()
        .add(FetchRealtionship(RelationContext.following, ''));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SearchBar(
            hintText: 'Search Subscription',
            textEditingController: _textEditingController,
            onTextChange: (val) {
              context
                  .bloc<RelationBloc>()
                  .add(FetchRealtionship(RelationContext.following, val));
            },
          ),
          BlocBuilder<RelationBloc, RelationState>(
            builder: (context, state) {
              if (state is RelationErrorState) {
                return JuntoErrorWidget(
                    errorMessage: 'Hmm, something went wrong');
              } else if (state is RelationLoadingState) {
                return Center(
                  child: JuntoProgressIndicator(),
                );
              } else if (state is RelationLoadedState) {
                final List<UserProfile> _followingMembers = state.following;
                if (_followingMembers.length > 0) {
                  return Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        final metrics = notification.metrics;
                        double scrollPercent =
                            (metrics.pixels / metrics.maxScrollExtent) * 100;
                        if (scrollPercent.roundToDouble() == 60.0 &&
                            state.followingResultCount >
                                _followingMembers.length) {
                          context
                              .bloc<RelationBloc>()
                              .add(FetchMoreRelationship(
                                RelationContext.following,
                                _textEditingController.value.text,
                              ));
                          return true;
                        }
                        return false;
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: _followingMembers
                            .map(
                              (dynamic subscription) =>
                                  MemberPreview(profile: subscription),
                            )
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return FeedPlaceholder(
                    placeholderText: 'No subscriptions yet!',
                    image: 'assets/images/junto-mobile__bench.png',
                  );
                }
              }

              return FeedPlaceholder(
                placeholderText: 'No subscriptions yet!',
                image: 'assets/images/junto-mobile__bench.png',
              );
            },
          ),
        ],
      ),
    );
  }
}
