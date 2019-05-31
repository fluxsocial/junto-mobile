import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import './degrees/degrees.dart';
import './../../components/expression_preview/expression_preview.dart';
import './perspectives/perspective_preview.dart';
import '../../scoped_models/scoped_user.dart';
import '../../typography/palette.dart';

// This screen shows a list of public expressions that can be filtered
// by channel or perspective
class JuntoCollective extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoCollectiveState();
  }
}

class JuntoCollectiveState extends State<JuntoCollective> {
  String _currentPerspective = 'JUNTO';

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
        _infinityColor = Color(0xff333333);

      } else if(degree == 'one') {
        _oneDegreeActive = true;
        _oneDegreeColor = Color(0xff333333);        
      } else if(degree == 'two') {
        _twoDegreesActive = true;
        _twoDegreesColor = Color(0xff333333);        
      } else if(degree == 'three') {
        _threeDegreesActive = true;
        _threeDegreesColor = Color(0xff333333);

      } else if(degree == 'four') {
        _fourDegreesActive = true;
        _fourDegreesColor = Color(0xff333333);        
      } else if(degree == 'five') {
        _fiveDegreesActive = true;
        _fiveDegreesColor = Color(0xff333333);

      } else if(degree == 'six') {
        _sixDegreesActive = true;
        _sixDegreesColor = Color(0xff333333);      

      }
    });
  }


  void _changePerspective(perspective) {
    setState(() {
      _currentPerspective = perspective;

      // re render feed          
    });  }

  _navPerspectives() {
    return ;
  }


  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        appBar: JuntoAppBar.getJuntoAppBar(
            'assets/images/junto-mobile__logo--collective.png',
            _currentPerspective,
            // ~ 28 character limit - tbd
            JuntoPalette.juntoBlue,
            JuntoPalette.juntoBlueLight,
            _navPerspectives()
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Drawer(
            elevation: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xffeeeeee), width: 1))),
                        alignment: Alignment.centerLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PERSPECTIVES',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff333333))),
                              Icon(Icons.add_circle_outline, size: 14)
                            ]),
                        height: 45,
                        margin: EdgeInsets.only(top: statusBarHeight)),
                    Expanded(
                        child: ListView(padding: EdgeInsets.all(0), children: [
                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          _changePerspective('JUNTO');

                          Navigator.pop(context);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('JUNTO')]),
                      ),
                    ),

                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          _changePerspective('FOLLOWING');

                          Navigator.pop(context);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('FOLLOWING')]),
                      ),
                    ),

                      ScopedModelDescendant<ScopedUser>(
                        builder: (context, child, model) => ListView(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              children: model.perspectives
                                  .map((perspective) => PerspectivePreview(
                                      perspective.perspectiveTitle, _changePerspective))
                                  .toList(),
                            ),
                      ),
                    ]))
                  ],
                )),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
          child: ListView(
            children: <Widget>[
              DegreesOfSeparation(_changeDegree, _infinityColor, _oneDegreeColor, _twoDegreesColor,
              _threeDegreesColor, _fourDegreesColor, _fiveDegreesColor, _sixDegreesColor),

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
        ),
        bottomNavigationBar: BottomNav());
  }
}
