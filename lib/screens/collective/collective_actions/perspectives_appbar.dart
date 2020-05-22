import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class PerspectivesAppBar extends StatelessWidget {
  PerspectivesAppBar({this.navigateBack});

  final Function navigateBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      width: MediaQuery.of(context).size.width,
      color: Colors.orange,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: navigateBack,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              width: 80,
              height: 42,
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              child: Icon(
                CustomIcons.back,
                color: Theme.of(context).primaryColorDark,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
