import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

/// Takes an un-named [ExpressionResult] to be displayed
class ShortformPreview extends StatefulWidget {
  const ShortformPreview({
    @required this.expression,
  });

  /// [ExpressionResponse] to be displayed
  final ExpressionResponse expression;

  @override
  State<StatefulWidget> createState() => ShortformPreviewState();
}

class ShortformPreviewState extends State<ShortformPreview> {
  String _hexOne;
  String _hexTwo;
  String shortformBody = '';

  @override
  void initState() {
    super.initState();
    shortformBody = widget.expression.expressionData.body;
    _hexOne = widget.expression.expressionData.background[0];
    _hexTwo = widget.expression.expressionData.background[1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.1, 0.9],
          colors: <Color>[HexColor.fromHex(_hexOne), HexColor.fromHex(_hexTwo)],
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width * (2/3),
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: Text(
        shortformBody,
        maxLines: 5,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
