import 'package:flutter/material.dart';

import './../palette.dart';
import './../custom_icons.dart';
import '../style.dart';

import '../components/appbar_border/appbar_border.dart';

import './perspectives/perspectives.dart';

import './../components/bottom_nav/bottom_nav.dart';
import './../components/expression_preview/expression_preview.dart';
import './../components/filter_channel_collective/filter_channel_collective.dart';

// import './../models/expressions.dart';
import './../models/expression.dart';

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

    expressions = Expression.fetchExpressions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: 
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: 
          AppBar(
              backgroundColor: JuntoPalette.juntoWhite,
              // backgroundColor: Colors.blue,
              brightness: Brightness.light,
              elevation: 0,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        Image.asset(
                            'assets/images/junto-mobile__logo--collective.png',
                            height: 20.0,
                            width: 20.0),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'JUNTO',
                            textAlign: TextAlign.center,
                            style: JuntoStyles.appbarTitle
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(CustomIcons.moon),
                      iconSize: 20.0,
                      color: JuntoPalette.juntoSleek,
                      tooltip: 'open notifcations',
                      onPressed: () {
               
                        },
                    ),
                  ])),),

        body: Container(
          decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
          child: Column(
            children: <Widget>[
              // App bar border
              AppbarBorder(JuntoPalette.juntoBlue),

              // perspectives
              Container(                
                height: 75.0,
                color: JuntoPalette.juntoWhite,
                padding: EdgeInsets.symmetric(horizontal: 17.0),
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

                      // Icon(Icons.arrow_right)
                      IconButton(                        
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.centerRight,
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => JuntoX()),
                        // );    
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => JuntoPerspectives()),
                        );                                                         
                        },
                      )
                    ]),
              ),
 
              // filter by channel
              FilterChannelCollective(),

              Expanded(
                child: ListView(
                children: 
                  expressions.map((expression) => 
                  ExpressionPreview(expression.expressionType, expression.title, expression.body, expression.image)).toList(),
              ))                                
            ],
          ),
        ),
        bottomNavigationBar: BottomNav());
  }
}