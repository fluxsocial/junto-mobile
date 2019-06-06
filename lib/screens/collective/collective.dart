import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


import './degrees/degrees.dart';
import './../../components/expression_preview/expression_preview.dart';
import '../../scoped_models/scoped_user.dart';
import '../../typography/palette.dart';

// This screen shows a list of public expressions that can be filtered
// by channel or perspective
class JuntoCollective extends StatefulWidget {
  var currentScreen = 'collective';
  final controller;

  JuntoCollective(this.controller);
  @override
  State<StatefulWidget> createState() {
    return JuntoCollectiveState();
  }
}

class JuntoCollectiveState extends State<JuntoCollective> {

  
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return 
      Container(
        decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
        child: ListView(
          controller: widget.controller,
          children: <Widget>[   
            DegreesOfSeparation(_changeDegree, _infinityColor, _oneDegreeColor, _twoDegreesColor,
            _threeDegreesColor, _fourDegreesColor, _fiveDegreesColor, _sixDegreesColor),

            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            //   color: Colors.white,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children:[
                  
            //       Text('# filter by channel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            //     ])
            // ),
            // expressions
            ScopedModelDescendant<ScopedUser>(
              builder: (context, child, model) => ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: model.collectiveExpressions
                        .map((expression) => ExpressionPreview(expression))
                        .toList(),
                  ),
            ),
          ],
        ),
      ); 
  }

  bool _infinityActive = true;
  bool _oneDegreeActive = false;
  bool _twoDegreesActive = false;
  bool _threeDegreesActive = false;
  bool _fourDegreesActive = false;
  bool _fiveDegreesActive = false;
  bool _sixDegreesActive = false;

  Color _degreeColor ;
  Color activeColor = Color(0xff333333);
  Color passiveColor = Color(0xff999999);
  Color _infinityColor = Color(0xff333333);
  Color _oneDegreeColor = Color(0xff999999);
  Color _twoDegreesColor = Color(0xff999999);
  Color _threeDegreesColor = Color(0xff999999);
  Color _fourDegreesColor = Color(0xff999999);
  Color _fiveDegreesColor = Color(0xff999999);
  Color _sixDegreesColor = Color(0xff999999);
  
  void _resetDegrees() {
    setState(() {
      _infinityActive = false;
      _oneDegreeActive = false;
      _twoDegreesActive = false;
      _threeDegreesActive = false;
      _fourDegreesActive = false;
      _fiveDegreesActive = false;
      _sixDegreesActive = false;

      _infinityColor = Color(0xff999999);
      _oneDegreeColor = Color(0xff999999);
      _twoDegreesColor = Color(0xff999999);
      _threeDegreesColor = Color(0xff999999);
      _fourDegreesColor = Color(0xff999999);
      _fiveDegreesColor = Color(0xff999999);
      _sixDegreesColor = Color(0xff999999);      
    });
  }

  void _changeDegree(degree) {
    setState(() {
      _resetDegrees();
      if (degree == 'infinity') {
        _infinityActive = true;
        _infinityColor = Color(0xffffffff);

      } else if(degree == 'one') {
        _oneDegreeActive = true;
        _oneDegreeColor = Color(0xffffffff);        
      } else if(degree == 'two') {
        _twoDegreesActive = true;
        _twoDegreesColor = Color(0xffffffff);        
      } else if(degree == 'three') {
        _threeDegreesActive = true;
        _threeDegreesColor = Color(0xffffffff);

      } else if(degree == 'four') {
        _fourDegreesActive = true;
        _fourDegreesColor = Color(0xffffffff);        
      } else if(degree == 'five') {
        _fiveDegreesActive = true;
        _fiveDegreesColor = Color(0xffffffff);

      } else if(degree == 'six') {
        _sixDegreesActive = true;
        _sixDegreesColor = Color(0xffffffff);      

      }
    });
  }  
}
