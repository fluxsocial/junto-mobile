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
class JuntoCollective extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JuntoAppBar.getJuntoAppBar(
          'assets/images/junto-mobile__logo--collective.png', 
          'JUNTO', 
          JuntoPalette.juntoBlue,
          JuntoPalette.juntoBlueLight
        ),

        body: Container(
          decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
          child: ListView(
            children: <Widget>[
              
              // perspectives
              CollectivePerspectives(),

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
