import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/screens/collective/degrees/degrees.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/providers/collective_provider/collective_provider.dart';


// This screen shows a list of public expressions that can be filtered
// by channel or perspective
class JuntoCollective extends StatefulWidget {
  var currentScreen = 'collective';

  // This controller is used to detect the scroll of the ListView 
  // to render the FAB dynamically
  final controller;
  JuntoCollective(this.controller);

  @override
  State<StatefulWidget> createState() {
    return JuntoCollectiveState();
  }
}

class JuntoCollectiveState extends State<JuntoCollective> {  
  bool _degreesOfSeparation = true;

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
        child: ListView(
          controller: widget.controller,
          children: <Widget>[   
            // Degrees of Separation Widget rendered only when on the 'JUNTO' perspective
            _degreesOfSeparation ? DegreesOfSeparation(_changeDegree, _infinityColor, _oneDegreeColor, _twoDegreesColor,
            _threeDegreesColor, _fourDegreesColor, _fiveDegreesColor, _sixDegreesColor) : SizedBox(),

            Consumer<CollectiveProvider>(
              builder: (context, collective, child) {
                return 
                ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: collective.collectiveExpressions
                      .map(
                          (expression) => ExpressionPreview(expression))
                      .toList(), 
                );                
              }
            )


          ],
        ),
      ); 
  }

  // Default colors for degrees
  Color _infinityColor = Color(0xff333333);
  Color _oneDegreeColor = Color(0xff999999);
  Color _twoDegreesColor = Color(0xff999999);
  Color _threeDegreesColor = Color(0xff999999);
  Color _fourDegreesColor = Color(0xff999999);
  Color _fiveDegreesColor = Color(0xff999999);
  Color _sixDegreesColor = Color(0xff999999);
  
  // Reset all degree colors to inactive
  void _resetDegrees() {
    setState(() {
      _infinityColor = Color(0xff999999);
      _oneDegreeColor = Color(0xff999999);
      _twoDegreesColor = Color(0xff999999);
      _threeDegreesColor = Color(0xff999999);
      _fourDegreesColor = Color(0xff999999);
      _fiveDegreesColor = Color(0xff999999);
      _sixDegreesColor = Color(0xff999999);      
    });
  }

  // Switch degrees
  void _changeDegree(degree) {
    setState(() {
      _resetDegrees();
      if (degree == 'infinity') {
        _infinityColor = Color(0xff333333);
      } else if(degree == 'one') {
        _oneDegreeColor = Color(0xff333333);        
      } else if(degree == 'two') {
        _twoDegreesColor = Color(0xff333333);        
      } else if(degree == 'three') {
        _threeDegreesColor = Color(0xff333333);
      } else if(degree == 'four') {
        _fourDegreesColor = Color(0xff333333);        
      } else if(degree == 'five') {
        _fiveDegreesColor = Color(0xff333333);

      } else if(degree == 'six') {
        _sixDegreesColor = Color(0xff333333);      
      }
    });
  }  
}
