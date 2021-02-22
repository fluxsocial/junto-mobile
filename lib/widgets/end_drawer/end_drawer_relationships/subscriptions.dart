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
    context.bloc<RelationBloc>().add(FetchRealtionship());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationBloc, RelationState>(
      builder: (context, state) {
        if (state is RelationErrorState) {
          print(state.message);
          return JuntoErrorWidget(errorMessage: 'Hmm, something went wrong');
        } else if (state is RelationLoadingState) {
          return Center(
            child: JuntoProgressIndicator(),
          );
        } else if (state is RelationLoadedState) {
          print('getting following');

          final List<UserProfile> _followingMembers = state.following;
          if (_followingMembers.length > 0) {
            return Container(
              child: Column(
                children: [
                  SearchBar(
                    hintText: 'Search Subscription',
                    textEditingController: _textEditingController,
                    onTextChange: (val) {
                      print('hello');
                      context.bloc<RelationBloc>().add(SearchRelationship(val));
                    },
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification info) {
                        if (info.metrics.pixels ==
                            info.metrics.maxScrollExtent) {
                          context
                              .bloc<RelationBloc>()
                              .add(FetchMoreRelationship());
                        }

                        return;
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
                  ),
                ],
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
    );
  }
}
