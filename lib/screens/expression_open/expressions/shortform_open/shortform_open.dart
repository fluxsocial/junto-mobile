import 'package:flutter/material.dart';

import '../../../../typography/palette.dart';
class ShortformOpen extends StatefulWidget {
  final shortformExpression;

  ShortformOpen(this.shortformExpression);

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

  _buildBackground() {
    if (_shortformBackground == 'zero') {
      setState(() {
        _gradientOne = Color(0xffffffff);
        _gradientTwo = Color(0xffffffff);
      });
    } else if (_shortformBackground == 'one') {
      setState(() {
        _gradientOne = JuntoPalette.juntoBlue;
        _gradientTwo = JuntoPalette.juntoBlueLight;
      });
    } else if (_shortformBackground == 'two') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPurple;
        _gradientTwo = JuntoPalette.juntoPurpleLight;
      });
    } else if (_shortformBackground == 'three') {
      setState(() {
        _gradientOne = JuntoPalette.juntoPurple;
        _gradientTwo = JuntoPalette.juntoBlue;
      });
    } else if (_shortformBackground == 'four') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoBlue;
      });
    } else if (_shortformBackground == 'five') {
      setState(() {
        _gradientOne = JuntoPalette.juntoGreen;
        _gradientTwo = JuntoPalette.juntoPurple;
      });
    }
  }

  @override
  void initState() {
    _shortformBackground = widget.shortformExpression.expression['expression_data']['ShortForm']['background'];
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
              colors: [
                _gradientOne,
                _gradientTwo
              ]
            )
          ),

          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * .3,
          ),
          width: 1000,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[                
              Text(
                widget.shortformExpression.expression['expression_data']['ShortForm']['body'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ); 
  }
}
