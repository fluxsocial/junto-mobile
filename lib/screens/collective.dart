import 'package:flutter/material.dart';

import './../custom_icons.dart';
import './../components/bottom_nav/bottom_nav.dart';
import './../components/expression_preview/expression_preview.dart';
import './../components/filter_channel_collective/filter_channel_collective.dart';

import './../models/expressions.dart';

class JuntoCollective extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Row(
            children: <Widget>[
              Image.asset('assets/images/junto-mobile__logo--collective.png',
                  height: 24.0, width: 24.0),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  'JUNTO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3),
                ),
              ),
            ],
          ),

          IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(CustomIcons.moon),
              color: Colors.black,
              tooltip: 'open notifcations',
              onPressed: () {
                // ...
              },
            ),
          ])
        ),
        body: Container(
          
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              // navigation border
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.lightBlue),
                  ),
                ),
              ),

              // perspectives
              Container(
                // width: 1000,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 17.0),
                foregroundDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: .75, color: Colors.grey),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'COLLECTIVE',
                        style: TextStyle(fontWeight: FontWeight.w600),
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
