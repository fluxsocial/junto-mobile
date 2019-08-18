import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

// This class renders a widget that enables the user to create a sphere
class SpheresCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15.0, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Create a Sphere'.toUpperCase(),
            style: const TextStyle(
              color: JuntoPalette.juntoGrey,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            child: Icon(
              Icons.add_circle_outline,
              size: 17,
              color: JuntoPalette.juntoGrey,
            ),
          )
        ],
      ),
    );
  }
}
