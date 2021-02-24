import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/screens/global_search/relations_bloc/relation_bloc.dart';
import './search_bar.dart';

class Connections extends StatefulWidget {
  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    context
        .bloc<RelationBloc>()
        .add(FetchRealtionship(RelationContext.connections));
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
          // get list of connections
          final List<UserProfile> _connectionsMembers = state.connections;

          if (_connectionsMembers.length > 0) {
            return Container(
              child: Column(
                children: [
                  SearchBar(
                    hintText: 'Search Connections',
                    textEditingController: _textEditingController,
                    onTextChange: (val) {
                      context.bloc<RelationBloc>().add(SearchRelationship(val));
                    },
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        final metrics = notification.metrics;
                        double scrollPercent =
                            (metrics.pixels / metrics.maxScrollExtent) * 100;
                        if (scrollPercent.roundToDouble() == 60.0 &&
                            state.connctionResultCount >
                                _connectionsMembers.length) {
                          context
                              .bloc<RelationBloc>()
                              .add(FetchMoreRelationship(
                                RelationContext.connections,
                              ));
                          return true;
                        }
                        return false;
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: _connectionsMembers
                            .map(
                              (dynamic connection) =>
                                  MemberPreview(profile: connection),
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
              placeholderText: 'No connections yet!',
              image: 'assets/images/junto-mobile__bench.png',
            );
          }
        }

        return FeedPlaceholder(
          placeholderText: 'No connections yet!',
          image: 'assets/images/junto-mobile__bench.png',
        );
      },
    );
  }
}
