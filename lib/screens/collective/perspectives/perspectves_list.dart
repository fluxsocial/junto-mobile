import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/on_perspectives_changed.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspective_item.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class PerspectivesList extends StatelessWidget {
  const PerspectivesList({
    Key key,
    this.collectiveViewNav,
  }) : super(key: key);

  final Function collectiveViewNav;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerspectivesBloc, PerspectivesState>(
      builder: (context, state) {
        if (state is PerspectivesError) {
          return Container(
            child: const Text(
              'hmm, something is up...',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          );
        }
        if (state is PerspectivesLoading) {
          return Center(child: JuntoProgressIndicator());
        }
        if (state is PerspectivesFetched) {
          return Column(
            children: <Widget>[
              // display Subscriptions perspective first
              ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children:
                    state.perspectives.map((PerspectiveModel perspective) {
                  if (perspective.isDefault == true) {
                    return PerspectiveItem(
                      perspective: perspective,
                      onTap: () {
                        collectiveViewNav();
                        onPerspectivesChanged(perspective, context);
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                }).toList(),
              ),
              // display rest of perspectives
              ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: state.perspectives.map(
                  (PerspectiveModel perspective) {
                    if (perspective.name != 'Connections' &&
                        perspective.name != 'Subscriptions') {
                      return GestureDetector(
                        child: PerspectiveItem(
                          perspective: perspective,
                          onTap: () {
                            collectiveViewNav();
                            onPerspectivesChanged(perspective, context);
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ).toList(),
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
