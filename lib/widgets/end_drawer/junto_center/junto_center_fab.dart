import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';

class JuntoCommunityCenterFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          FadeRoute<void>(
            child: JuntoCreate(
              channels: <String>[],
              address: '48b97134-1a4d-deb0-b27c-9bcdfc33f386',
              expressionContext: ExpressionContext.Group,
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(1000),
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.secondaryVariant,
            Theme.of(context).colorScheme.primaryVariant,
          ]),
        ),
        child: Icon(
          CustomIcons.create,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
