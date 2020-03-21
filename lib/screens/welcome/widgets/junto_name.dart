import 'package:flutter/material.dart';

class JuntoName extends StatelessWidget {
  const JuntoName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .05),
      margin: const EdgeInsets.only(bottom: 25),
      child: Text(
        'JUNTO',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w400,
          fontSize: 28,
          letterSpacing: 1.8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
