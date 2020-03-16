import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/perspectives.dart';

class JuntoCollectiveActions extends StatelessWidget {
  const JuntoCollectiveActions({
    this.userProfile,
    this.changePerspective,
  });

  final UserData userProfile;
  final ValueChanged<PerspectiveModel> changePerspective;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height - 90,
          child: JuntoPerspectives(
            userProfile: userProfile,
            changePerspective: changePerspective,
          ),
        ),
      ],
    );
  }
}
