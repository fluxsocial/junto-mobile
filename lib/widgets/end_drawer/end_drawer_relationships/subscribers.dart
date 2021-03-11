import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:junto_beta_mobile/screens/global_search/relations_bloc/relation_bloc.dart';

import './search_bar.dart';

class Subscribers extends StatefulWidget {
  @override
  _SubscribersState createState() => _SubscribersState();
}

class _SubscribersState extends State<Subscribers>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    context
        .read<RelationBloc>()
        .add(FetchRealtionship(RelationContext.follower, ''));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: SearchBar(
              hintText: 'Search',
              textEditingController: _textEditingController,
              onTextChange: (val) {
                context
                    .read<RelationBloc>()
                    .add(FetchRealtionship(RelationContext.follower, val));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<RelationBloc, RelationState>(
              builder: (context, state) {
                if (state is RelationErrorState) {
                  print(state.message);
                  return JuntoErrorWidget(
                      errorMessage: 'Hmm, something went wrong');
                } else if (state is RelationLoadingState) {
                  return Center(
                    child: JuntoProgressIndicator(),
                  );
                } else if (state is RelationLoadedState) {
                  final List<UserProfile> _followerMembers = state.followers;

                  if (_followerMembers.length > 0) {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        final metrics = notification.metrics;
                        double scrollPercent =
                            (metrics.pixels / metrics.maxScrollExtent) * 100;
                        if (scrollPercent.roundToDouble() == 60.0 &&
                            state.followerResultCount >
                                _followerMembers.length) {
                          context
                              .read<RelationBloc>()
                              .add(FetchMoreRelationship(
                                RelationContext.follower,
                                _textEditingController.value.text,
                              ));
                          return true;
                        }
                        return false;
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: _followerMembers
                            .map(
                              (dynamic subscriber) =>
                                  MemberPreview(profile: subscriber),
                            )
                            .toList(),
                      ),
                    );
                  } else {
                    return FeedPlaceholder(
                      placeholderText: 'No subscribers yet!',
                      image: 'assets/images/junto-mobile__bench.png',
                    );
                  }
                }

                return Center(
                  child: JuntoProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
