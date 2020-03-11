import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 25),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.2),
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Icon(
          CustomIcons.back,
          size: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}
