
import 'package:flutter/material.dart';

import './../theme.dart';
import './../custom_icons.dart';

import './../components/bottom_nav/bottom_nav.dart';
import './../components/expression_preview/expression_preview.dart';
import './../components/filter_channel_collective/filter_channel_collective.dart';

import './../models/expressions.dart';

class JuntoCollective extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _JuntoCollectiveState();
  }
}

class _JuntoCollectiveState extends State {
  List expressions; 

  initState() {
    super.initState();

    expressions = Expressions.fetchExpressions(); 
  }

  Widget _collectiveExpressions(BuildContext context, int index) {
    return ExpressionPreview(expressions, index);
  }

  @override
  Widget build(BuildContext context) {
      
    return Scaffold(

        appBar: 
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            backgroundColor: JuntoTheme.juntoWhite,
            // backgroundColor: Colors.blue,
            brightness: Brightness.light,
            elevation: 0,   
            title: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Row(
                children: <Widget>[
                  Image.asset('assets/images/junto-mobile__logo--collective.png',
                      height: 20.0, width: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'JUNTO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: JuntoTheme.juntoSleek,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3),
                    ),
                  ),
                ],
              ),

          IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(CustomIcons.moon),
              iconSize: 20.0,
              color: JuntoTheme.juntoSleek,
              tooltip: 'open notifcations',
              onPressed: () {
                // ...
              },
            ),
          ])
        ),),
        body: 
        
        Container(
          
          decoration: BoxDecoration(color: JuntoTheme.juntoWhite),
          child: Column(
            children: <Widget>[
              // navigation border
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: JuntoTheme.juntoBlue),
                  ),
                ),
              ),

              // perspectives
              Container(
                // height: 45.0,
                color: JuntoTheme.juntoWhite,
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 17.0),
                foregroundDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'COLLECTIVE',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.centerRight,
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {},
                      )
                    ]),
              ),
            
              // filter by channel
              FilterChannelCollective(),

              Expanded(
                child: ListView.builder(
                    itemBuilder: _collectiveExpressions, itemCount: expressions.length),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNav());
  }
}
