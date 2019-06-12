import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pack_open_appbar/pack_open_appbar.dart';
import '../../../scoped_models/scoped_user.dart';
import '../../../components/expression_preview/expression_preview.dart';
import '../../../custom_icons.dart';
import '../../../typography/palette.dart';


class PackOpen extends StatefulWidget {
  final packTitle;
  final packUser;
  final packImage;

  PackOpen(this.packTitle, this.packUser, this.packImage);

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child:
            PackOpenAppbar(widget.packTitle, widget.packUser, widget.packImage),
      ),

      floatingActionButton: 
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Color(0xffeeeeee), width: .5),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Color(0xff999999),
                blurRadius: 3,
                offset: Offset(1, 2),
              )
            ],
          ),
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          padding: EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width * .75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(                
                width: MediaQuery.of(context).size.width * .37,
                child: Icon(CustomIcons.half_lotus, size: 17, color: JuntoPalette.juntoGrey),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .37,
                child:
                  RotatedBox(
                    quarterTurns: 2,
                    child: Icon(CustomIcons.triangle, size: 17, color: JuntoPalette.juntoGrey)
                  )
              )            
          ],)
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked ,

      body: ScopedModelDescendant<ScopedUser>(
        builder: (context, child, model) => ListView(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: model.collectiveExpressions
                  .map((expression) => ExpressionPreview(expression))
                  .toList(),
            ),
      ),
    );
  }
}
