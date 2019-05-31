import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import './collective_perspectives/collective_perspectives.dart';
import './../../components/expression_preview/expression_preview.dart';
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
  bool _infinityActive = true;
  bool _oneDegreeActive = false;
  bool _twoDegreesActive = false;
  bool _threeDegreesActive = false;  
  bool _fourDegreesActive = false;
  bool _fiveDegreesActive = false;
  bool _sixDegreesActive = false;  

  void _resetDegrees() {
    setState(() {
     _infinityActive = false;
     _oneDegreeActive = false;
     _twoDegreesActive = false;
     _threeDegreesActive = false;  
     _fourDegreesActive = false;
     _fiveDegreesActive = false;
     _sixDegreesActive = false;        
    });
  }

  _navPerspectives() {
    Navigator.pushReplacementNamed(context, '/perspectives');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JuntoAppBar.getJuntoAppBar(
          'assets/images/junto-mobile__logo--collective.png', 
          'COLLECTIVE', 
          JuntoPalette.juntoBlue,
          JuntoPalette.juntoBlueLight,
          _navPerspectives
        ),

        body: Container(
          decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
          child: ListView(
            children: <Widget>[
              
              // perspectives
              // CollectivePerspectives(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                color: Colors.white,
                foregroundDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
                  ),
                ),                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 10),
                  //   child: Text('DEGREES OF SEPARATION', style: TextStyle(color: Color(0xff333333), fontWeight: FontWeight.w700))
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _infinityActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('oo', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _infinityActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),                    
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _oneDegreeActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('i', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _oneDegreeActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _twoDegreesActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('ii', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _twoDegreesActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),
                 
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _threeDegreesActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('iii', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _threeDegreesActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _fourDegreesActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('iv', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _fourDegreesActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),                    
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _fiveDegreesActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('v', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _fiveDegreesActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _resetDegrees();
                            _sixDegreesActive = true;
                          });
                        },
                        child: 
                          Container(
                            child: Text('vi', 
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _sixDegreesActive == true ? Color(0xff333333) : Color(0xff999999),))
                          ),
                      ),                                                                                                   
                    ],
                  )

                ],)                
              ),

              // expressions
              ScopedModelDescendant<ScopedUser>(
                  builder: (context, child, model) => 
                    ListView(
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
