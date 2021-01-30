import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

import 'bloc/circle_bloc.dart';

class CirclesListAll extends StatelessWidget with ListDistinct {
  const CirclesListAll({
    this.userProfile,
  });

  final UserData userProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    ...state.groups.asMap().entries.map((entry) {
                      final index = entry.key;
                      final group = entry.value;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  SphereOpen(groupIndex: index),
                            ),
                          );
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
    );
  }
}
