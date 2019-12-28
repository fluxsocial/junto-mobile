import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/expression.dart';

/// Takes an un-named [ExpressionResult] to be displayed
class ShortformPreview extends StatefulWidget {
  const ShortformPreview({
    @required this.expression,
  });

  /// [CentralizedExpressionResponse] to be displayed
  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() => ShortformPreviewState();
}

class ShortformPreviewState extends State<ShortformPreview> {
  //ignore:unused_field
  Color _gradientOne;
  //ignore:unused_field
  Color _gradientTwo;
  String shortformBody = '';

  @override
  void initState() {
    super.initState();
    _buildBackground();
    shortformBody = widget.expression.expressionData.body;
  }

  void _buildBackground() {
    final String shortformBackground =
        widget.expression.expressionData.background;

    if (shortformBackground == 'zero') {
      setState(() {
        _gradientOne = JuntoPalette.juntoWhite;
        _gradientTwo = JuntoPalette.juntoWhite;
      });
    } else if (shortformBackground == 'one') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPrimary;
        _gradientTwo = JuntoPalette.juntoPrimaryLight;
      });
    } else if (shortformBackground == 'two') {
      setState(() {
        _gradientOne = JuntoPalette.juntoSecondary;
        _gradientTwo = JuntoPalette.juntoSecondaryLight;
      });
    } else if (shortformBackground == 'three') {
      setState(() {
        _gradientOne = JuntoPalette.juntoSecondary;
        _gradientTwo = JuntoPalette.juntoPrimary;
      });
    } else if (shortformBackground == 'four') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoPrimary;
      });
    } else if (shortformBackground == 'five') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoSecondary;
      });
    } else {
      setState(() {
        _gradientOne = JuntoPalette.juntoPrimary;
        _gradientTwo = JuntoPalette.juntoSecondary;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
        minHeight: MediaQuery.of(context).size.height * .33,
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: Text(
        shortformBody,
        maxLines: 5,
        textAlign: TextAlign.center,
        style: JuntoStyles.shortformPreviewTitle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
