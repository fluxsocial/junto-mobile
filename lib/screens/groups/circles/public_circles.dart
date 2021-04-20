import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/custom_refresh.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/search_bar.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';

import 'bloc/circle_bloc.dart';

class PublicCircles extends StatefulWidget with ListDistinct {
  PublicCircles({
    this.userProfile,
    this.onGroupSelected,
  });

  final UserData userProfile;
  final Function(Group) onGroupSelected;

  @override
  _PublicCirclesState createState() => _PublicCirclesState();
}

class _PublicCirclesState extends State<PublicCircles> {
  double position = 0.0;

  double sensitivityFactor = 20.0;

  TextEditingController _subController;

  @override
  Widget build(BuildContext context) {
    return CustomRefresh(
      refresh: () {
        context.read<CircleBloc>().add(FetchPublicCircle());
      },
      child: BlocBuilder<CircleBloc, CircleState>(
        builder: (context, state) {
          if (state is CircleError) {
            return Expanded(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0.0, -50),
                  child: const Text(
                    'Hmm, something is up...',
                  ),
                ),
              ),
            );
          }
          if (state is CircleLoaded) {
            final list = state.publicGroups;
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: SearchBar(
                    hintText: 'Search',
                    textEditingController: _subController,
                    onTextChange: (val) {
                      context
                          .read<CircleBloc>()
                          .add(FetchPublicCircle(query: val));
                    },
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      final metrics = notification.metrics;
                      double scrollPercent =
                          (metrics.pixels / metrics.maxScrollExtent) * 100;

                      if (notification.metrics.pixels - position >=
                          sensitivityFactor) {
                        position = notification.metrics.pixels;
                        if (scrollPercent.toInt() >= 80) {
                          context
                              .read<CircleBloc>()
                              .add(FetchMorePublicCircle());

                          return true;
                        }
                      }

                      if (position - notification.metrics.pixels >=
                          sensitivityFactor) {
                        position = notification.metrics.pixels;
                      }

                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        final group = list[index];
                        return GestureDetector(
                          onTap: () {
                            widget.onGroupSelected(group);

                            context
                                .read<ChannelFilteringBloc>()
                                .add(FilterClear());
                          },
                          child: CirclePreview(
                            group: group,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Transform.translate(
              offset: const Offset(0.0, -50),
              child: JuntoProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
