import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

// This class renders a widget that enables the user to create a sphere
class SpheresCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Create a sphere',
            style: TextStyle(
              color: JuntoPalette.juntoGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            child: const Text(
              '+',
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
