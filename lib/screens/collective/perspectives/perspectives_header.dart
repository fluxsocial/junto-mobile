import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';

class PerspectivesHeader extends StatelessWidget {
  const PerspectivesHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Perspectives',
          style: Theme.of(context).textTheme.headline4,
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute<dynamic>(
                builder: (ctx) => CreatePerspectivePage(),
              ),
            );
          },
          icon: Icon(
            Icons.add,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
