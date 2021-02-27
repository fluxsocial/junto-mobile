import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/circle_refresh.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/on_perspectives_changed.dart';

import 'bloc/circle_bloc.dart';

class CirclesListAll extends StatelessWidget with ListDistinct {
  const CirclesListAll({
    this.userProfile,
    this.onGroupSelected,
  });

  final UserData userProfile;
  final Function(Group) onGroupSelected;

  @override
  Widget build(BuildContext context) {
    return CircleRefresh(
      child: Column(
        children: <Widget>[
          if (userProfile != null)
            BlocBuilder<CircleBloc, CircleState>(
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
                  return Expanded(
                      child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      JuntoCollectivePreview(onGroupSelected: onGroupSelected),
                      ...state.groups.map((group) {
                        return GestureDetector(
                          onTap: () {
                            onGroupSelected(group);
                          },
                          child: CirclePreview(
                            group: group,
                          ),
                        );
                      }).toList(),
                    ],
                  ));
                }
                return Expanded(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: JuntoProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class JuntoCollectivePreview extends StatelessWidget {
  const JuntoCollectivePreview({this.onGroupSelected});

  final Function onGroupSelected;

  @override
  Widget build(BuildContext context) {
    final juntoPerspective = PerspectiveModel(
      address: null,
      name: 'JUNTO',
      about: null,
      creator: null,
      createdAt: null,
      isDefault: true,
      userCount: null,
      users: null,
    );

    return GestureDetector(
      onTap: () {
        onPerspectivesChanged(juntoPerspective, context);

        onGroupSelected(
          Group(address: 'junto-collective-group'),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            ClipOval(
              child: ImageWrapper(
                  imageUrl: 'assets/images/junto-mobile__logo--rainbow.png',
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String _) {
                    return Container(
                      alignment: Alignment.center,
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const <double>[0.3, 0.9],
                          colors: <Color>[
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        CustomIcons.spheres,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 17,
                      ),
                    );
                  }),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('c/junto',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(
                      'Junto Collective',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
