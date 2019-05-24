import 'package:flutter/material.dart';

import '../../components/appbar/appbar_border/appbar_border.dart';
import '../../typography/palette.dart';
import './expression_open_profile/expression_open_profile.dart';
import './expression_open_shortreply/expression_open_shortreply.dart';
import './expression_open_bottom/expression_open_bottom.dart';
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
      appBar: 
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(CustomIcons.back_arrow_left,
                            color: JuntoPalette.juntoSleek, size: 24),
                      ),
                      Icon(Icons.bookmark_border,
                          color: JuntoPalette.juntoSleek, size: 24)
                    ],
                  ),
              )
          ),
        ),

      body: 
      
      Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppbarBorder(Color(0xffeeeeee)),
            Expanded(
              child: ListView(children: [

                ExpressionOpenProfile(),

                _buildExpression(),

                ExpressionOpenBottom(channelOne: expression.channelOne, channelTwo: expression.channelTwo, channelThree: expression.channelThree, time: expression.time)

              ]),
            ),

            ExpressionOpenShortreply()     
          ],

          
        ),
      ),
    );
  }
}
