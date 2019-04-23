import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/scoped_expressions.dart';

// typography + icons
import '../../typography/palette.dart';

// app bar + bottom nav
import '../../components/appbar/appbar.dart';
import '../../components/appbar/appbar_border/appbar_border.dart';
import './../../components/bottom_nav/bottom_nav.dart';

// filter channel
import './../../components/filter/filter_channels/filter_channels_collective.dart';

// expression preview + model
import './../../components/expression_preview/expression_preview.dart';

class JuntoCollective extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JuntoAppBar.getJuntoAppBar(
            'assets/images/junto-mobile__logo--collective.png', 'JUNTO'),
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
                          Navigator.pushReplacementNamed(
                              context, '/perspectives');
                        },
                      )
                    ]),
              ),

              // filter by channel
              FilterChannelCollective(),

              ScopedModelDescendant<ScopedExpressions>(
                  builder: (context, child, model) => Expanded(
                          child: ListView(
                        children: model.expressions
                            .map((expression) => ExpressionPreview(
                                expression.expressionType,
                                expression.title,
                                expression.body,
                                expression.image))
                            .toList(),
                      )))
            ],
          ),
        ),
        bottomNavigationBar: BottomNav());
  }
}


              // Expanded(
              //   child: ListView(
              //   children:
              //     _collectiveExpressions.map((expression) =>
              //     ExpressionPreview(expression.expressionType, expression.title, expression.body, expression.image)).toList(),
              // ))