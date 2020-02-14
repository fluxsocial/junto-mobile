import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class ShortformOpen extends StatefulWidget {
  const ShortformOpen(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() {
    return ShortformOpenState();
  }
}

class ShortformOpenState extends State<ShortformOpen> {
  String _shortformBody;

  @override
  void initState() {
    _shortformBody = widget.expression.expressionData.body;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.1, 0.9],
          colors: <Color>[
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary
          ],
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .4,
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _shortformBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
