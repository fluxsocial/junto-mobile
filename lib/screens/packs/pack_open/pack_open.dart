import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';

import './pack_open_fab/pack_open_fab.dart';
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
  // Controller for PageView
  final controller = PageController(initialPage: 0);
  
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    DefaultTabController(
      length: 2,
      
      child: 
      Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: PackOpenAppbar(widget.packTitle, widget.packUser, widget.packImage),
      ),
    
      body:   
        Column(children: <Widget>[  
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * .5,
                  child: Icon(CustomIcons.half_lotus, size: 17),
                  
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))
                  ),                  
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .5,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(CustomIcons.triangle, size: 17)
                  )
                )
            ],)
          ),

          // Expanded(
          //   child: 
          //     ScopedModelDescendant<ScopedUser>(
          //       builder: (context, child, model) => ListView(
          //             controller: _hideFABController,
          //             children: model.collectiveExpressions
          //                 .map((expression) => ExpressionPreview(expression))
          //                 .toList(),
          //           ),
          //     ),            
          // )
        ],)    
      ) 
    );
  }
}
