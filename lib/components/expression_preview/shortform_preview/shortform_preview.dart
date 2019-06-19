import 'package:flutter/material.dart';

import './../../../typography/palette.dart';
import '../../../screens/expression_open/expression_open.dart';

class ShortformPreview extends StatefulWidget {
  final String _shortformBackground;
  final String _shortformText;

  ShortformPreview(this._shortformBackground, this._shortformText);

  @override
  State<StatefulWidget> createState() {
    return ShortformPreviewState();
  }
}

class ShortformPreviewState extends State<ShortformPreview> {
  Color _gradientOne;
  Color _gradientTwo;

  _buildBackground() {
    if (widget._shortformBackground == 'zero') {
      setState(() {
        _gradientOne = Color(0xffffffff);
        _gradientTwo = Color(0xffffffff);
      });
    } else if (widget._shortformBackground == 'one') {
      setState(() {
        _gradientOne = JuntoPalette.juntoBlue;
        _gradientTwo = JuntoPalette.juntoBlueLight;
      });
    } else if (widget._shortformBackground == 'two') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPurple;
        _gradientTwo = JuntoPalette.juntoPurpleLight;
      });
    } else if (widget._shortformBackground == 'three') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPurple;
        _gradientTwo = JuntoPalette.juntoBlue;
      });
    } else if (widget._shortformBackground == 'four') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoBlue;
      });
    } else if (widget._shortformBackground == 'five') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoPurple;
      });
    }
  }

  @override
  void initState() {
    _buildBackground();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.1, 0.9],
                colors: [_gradientOne, _gradientTwo])),

        constraints: BoxConstraints(
          minHeight: 240,
        ),
        width: 1000,
        // color: Colors.lightBlue,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget._shortformText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        ),
    );
  }
}
