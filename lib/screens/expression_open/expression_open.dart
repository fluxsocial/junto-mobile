import 'package:flutter/material.dart';

// import '../../components/appbar/appbar_border/appbar_border.dart';
import '../../typography/palette.dart';
import './expression_open_profile/expression_open_profile.dart';
import './expression_open_shortreply/expression_open_shortreply.dart';
import './expression_open_bottom/expression_open_bottom.dart';
import './expression_open_response/expression_open_response.dart';
import './expression_open_replies_text/expression_open_replies_text.dart';
import '../../custom_icons.dart';
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
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(CustomIcons.back_arrow_left,
                      color: JuntoPalette.juntoSleek, size: 24),
                ),
                // Icon(Icons.bookmark_border,
                //     color: JuntoPalette.juntoSleek, size: 24)
              ],
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.1, 0.9],
                        colors: [Color(0xffeeeeee), Color(0xffeeeeee)])),
              )),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: [
                ExpressionOpenProfile(),
                _buildExpression(),
                ExpressionOpenBottom(
                    channelOne: expression.channelOne,
                    channelTwo: expression.channelTwo,
                    channelThree: expression.channelThree,
                    time: expression.time),
                // ExpressionOpenResponse(),
                // ExpressionOpenRepliesText()
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__riley.png',
                            height: 36.0,
                            width: 36.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: .5))
                            ),                          
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width - 66,
                                  child: 
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Text('Riley Wagner', style: TextStyle(fontWeight: FontWeight.w700)),
                                          SizedBox(width: 5),
                                          Text('ryewags'),
                                        ],),

                                        Icon(CustomIcons.more, size: 20)

                                      ],
                                    ),                                  
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  width: MediaQuery.of(context).size.width - 66,
                                  child: Text(
                                      'Hi this is a comment preview',
                                      style: TextStyle(fontSize: 15)),
                                ),

                                Container(
                                  child: Text('5 MINUTES AGO', style: TextStyle(fontSize: 10, color: Color(0xff555555)))
                                )
                              ],
                            ))
                      ],
                    )),                                                                  
              ]),
            ),
            ExpressionOpenShortreply()
          ],
        ),
      ),
    );
  }
}
