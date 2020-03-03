import 'package:flutter/material.dart';

class JuntoHorizontalSeparator extends StatelessWidget {
  const JuntoHorizontalSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Theme.of(context).primaryColorDark.withOpacity(.12),
                offset: const Offset(0.0, 6.0),
                blurRadius: 9),
          ]),
    );
  }
}
