import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/perspectives.dart';

class JuntoCollectiveActions extends StatelessWidget {
  const JuntoCollectiveActions();

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
          child: JuntoPerspectives(),
        ),
      ],
    );
  }
}
