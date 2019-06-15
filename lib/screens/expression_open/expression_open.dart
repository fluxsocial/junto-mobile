import 'package:flutter/material.dart';

import './expression_open_appbar/expression_open_appbar.dart';
import './expression_open_top/expression_open_top.dart';
import './expression_open_shortreply/expression_open_shortreply.dart';
import './expression_open_bottom/expression_open_bottom.dart';
import './expression_open_showreplies/expression_open_showreplies.dart';
import './longform_open.dart';

class ExpressionOpen extends StatelessWidget {
  final expression;

  ExpressionOpen(this.expression);

  @override
  Widget build(BuildContext context) {
    _buildExpression() {
      if (expression.expressionType == 'longform') {
        return LongformOpen(expression);
      } else {
        return Container(child: Text('hellos'));
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: ExpressionOpenAppbar()
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: [
                ExpressionOpenTop(),
                _buildExpression(),
                ExpressionOpenBottom(
                    channelOne: expression.channelOne,
                    channelTwo: expression.channelTwo,
                    channelThree: expression.channelThree,
                    time: expression.time),
                ExpressionOpenShowReplies(),
                // Container(
                //     padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         ClipOval(
                //           child: Image.asset(
                //             'assets/images/junto-mobile__riley.png',
                //             height: 36.0,
                //             width: 36.0,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         Container(
                //             padding: EdgeInsets.only(bottom: 15),
                //             decoration: BoxDecoration(
                //               border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: .5))
                //             ),                          
                //             margin: EdgeInsets.only(left: 10),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: <Widget>[
                //                 Container(
                //                   width: MediaQuery.of(context).size.width - 66,
                //                   child: 
                //                     Row(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                       children: <Widget>[
                //                         Row(children: <Widget>[
                //                           Text('Riley Wagner', style: TextStyle(fontWeight: FontWeight.w700)),
                //                           SizedBox(width: 5),
                //                           Text('ryewags'),
                //                         ],),

                //                         Icon(CustomIcons.more, size: 20)

                //                       ],
                //                     ),                                  
                //                 ),

                //                 Container(
                //                   margin: EdgeInsets.only(top: 5, bottom: 5),
                //                   width: MediaQuery.of(context).size.width - 66,
                //                   child: Text(
                //                       'Hi this is a comment preview',
                //                       style: TextStyle(fontSize: 15)),
                //                 ),

                //                 Container(
                //                   child: Text('5 MINUTES AGO', style: TextStyle(fontSize: 10, color: Color(0xff555555)))
                //                 )
                //               ],
                //             ))
                //       ],
                //     )),                                                                  
              ]),
            ),
            ExpressionOpenShortreply()
          ],
        ),
      ),
    );
  }
}
