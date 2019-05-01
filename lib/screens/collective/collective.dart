import 'package:flutter/material.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import './../../components/expression_preview/expression_preview.dart';
import '../../scoped_models/scoped_expressions.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../typography/palette.dart';

class JuntoCollective extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JuntoAppBar.getJuntoAppBar(
          'assets/images/junto-mobile__logo--collective.png', 
          'JUNTO', 
          JuntoPalette.juntoBlue
        ),

        body: Container(
          decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
          child: ListView(
            children: <Widget>[
              
              // perspectives
              Container(
                height: 75.0,
                color: JuntoPalette.juntoWhite,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/perspectives');
                        },
                      )
                    ]),
              ),

              // expressions
              ScopedModelDescendant<ScopedExpressions>(
                  builder: (context, child, model) => 
                    ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: model.expressions
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
