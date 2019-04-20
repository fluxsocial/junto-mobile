
import 'package:flutter/material.dart';

// typography + icons 
import '../palette.dart';

// app bar + bottom nav
import '../components/appbar/appbar.dart';
import '../components/appbar_border/appbar_border.dart';
import './../components/bottom_nav/bottom_nav.dart';

// perspectives
import './perspectives/perspectives.dart';

// filter channel
import './../components/filter_channel_collective/filter_channel_collective.dart';

// expression preview + model
import './../models/expression.dart';
import './../components/expression_preview/expression_preview.dart';


class JuntoCollective extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JuntoCollectiveState();
  }
}

class _JuntoCollectiveState extends State {
  List _collectiveExpressions;

  initState() {
    super.initState();

   _collectiveExpressions = Expression.fetchExpressions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: juntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--collective.png', 'JUNTO'),

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
                  _collectiveExpressions.map((expression) => 
                  ExpressionPreview(expression.expressionType, expression.title, expression.body, expression.image)).toList(),
              ))                                
            ],
          ),
        ),
        bottomNavigationBar: BottomNav());
  }
}