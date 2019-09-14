import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/palette.dart';

class ShortformOpen extends StatefulWidget {
  const ShortformOpen(this.shortformExpression);

  final Expression shortformExpression;

  @override
  State<StatefulWidget> createState() {
    return ShortformOpenState();
  }
}

class ShortformOpenState extends State<ShortformOpen> {
  String _shortformBackground;
  String _shortformBody;
  Color _gradientOne;
  Color _gradientTwo;

  void _buildBackground() {
    if (_shortformBackground == 'zero') {
      setState(() {
        _gradientOne = const Color(0xffffffff);
        _gradientTwo = const Color(0xffffffff);
      });
    } else if (_shortformBackground == 'one') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPrimary;
        _gradientTwo = JuntoPalette.juntoPrimaryLight;
      });
    } else if (_shortformBackground == 'two') {
      setState(() {
        _gradientOne = JuntoPalette.juntoSecondary;
        _gradientTwo = JuntoPalette.juntoSecondaryLight;
      });
    } else if (_shortformBackground == 'three') {
      setState(() {
        _gradientOne = JuntoPalette.juntoSecondary;
        _gradientTwo = JuntoPalette.juntoPrimary;
      });
    } else if (_shortformBackground == 'four') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoPrimary;
      });
    } else if (_shortformBackground == 'five') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoSecondary;
      });
    }
  }

  @override
  void initState() {
    _shortformBody =
        widget.shortformExpression.expression.expressionContent['body'];
    _shortformBackground =
        widget.shortformExpression.expression.expressionContent['background'];
    _buildBackground();

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
          colors: <Color>[_gradientOne, _gradientTwo],
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .3,
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
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
