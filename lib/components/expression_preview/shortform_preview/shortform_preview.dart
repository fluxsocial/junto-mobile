import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

/// Takes an un-named [ExpressionResult] to be displayed
class ShortformPreview extends StatefulWidget {
  const ShortformPreview(this.expression);

  /// [ExpressionResult] to be displayed
  final ExpressionResult expression;

  @override
  State<StatefulWidget> createState() => ShortformPreviewState();
}

class ShortformPreviewState extends State<ShortformPreview> {
  Color _gradientOne;
  Color _gradientTwo;
  String shortformBody = '';

  @override
  void initState() {
    super.initState();
    _buildBackground();
    shortformBody =
        widget.expression.result[0].expression.expressionContent['body'];
  }

  void _buildBackground() {
    final String shortformBackground =
        widget.expression.result[0].expression.expressionContent['background'];

    if (shortformBackground == 'zero') {
      setState(() {
        _gradientOne = const Color(0xffffffff);
        _gradientTwo = const Color(0xffffffff);
      });
    } else if (shortformBackground == 'one') {
      setState(() {
        _gradientOne = JuntoPalette.juntoBlue;
        _gradientTwo = JuntoPalette.juntoBlueLight;
      });
    } else if (shortformBackground == 'two') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPurple;
        _gradientTwo = JuntoPalette.juntoPurpleLight;
      });
    } else if (shortformBackground == 'three') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPurple;
        _gradientTwo = JuntoPalette.juntoBlue;
      });
    } else if (shortformBackground == 'four') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoBlue;
      });
    } else if (shortformBackground == 'five') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoPurple;
      });
    }
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
            _gradientOne,
            _gradientTwo,
          ],
        ),
      ),
      constraints: const BoxConstraints(
        minHeight: 240,
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            shortformBody,
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
