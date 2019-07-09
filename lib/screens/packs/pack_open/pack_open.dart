import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';

import './pack_open_appbar/pack_open_appbar.dart';
import '../../../scoped_models/scoped_user.dart';
import '../../../components/expression_preview/expression_preview.dart';
import '../../../custom_icons.dart';
import '../../../typography/palette.dart';

import './pack_open_public/pack_open_public.dart';
import './pack_open_private/pack_open_private.dart';

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
  bool publicActive = true;

  @override
  void initState() {
    super.initState();
  }

  _switchScreen() {

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45),
              child: PackOpenAppbar(
                  widget.packTitle, widget.packUser, widget.packImage),
            ),
            body: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: .75))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            controller.jumpToPage(0);
                          },
                          child:    
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              width: MediaQuery.of(context).size.width * .5,
                              child: Icon(CustomIcons.half_lotus,
                                  size: 17, color: publicActive ? Color(0xff333333) : Color(0xff999999)),
                              // decoration: BoxDecoration(border: Border(
                              //   bottom: publicActive ? BorderSide(color: Color(0xff333333), width: 1.5) : BorderSide(width: 0)
                              // ))
                            ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.jumpToPage(1);
                          },
                          child: 
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                                width: MediaQuery.of(context).size.width * .5,
                                child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Icon(CustomIcons.triangle,
                                        size: 17, color: publicActive ? Color(0xff999999) : Color(0xff333333))),
                              // decoration: BoxDecoration(border: Border(
                              //   bottom: publicActive == false ? BorderSide(color: Color(0xff333333), width: 1.5) : BorderSide(width: 0)
                              // ))                                    
                            ),
                        )
                                    
                      ],
                    )),
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (int) {
                      if(int == 0) {
                        setState(() {
                          publicActive = true;
                        });
                      } else if (int == 1) {
                        setState(() {
                          publicActive = false;
                        });
                      }
                    },
                    children: <Widget>[PackOpenPublic(), PackOpenPrivate()],
                  ),
                )
              ],
            )));
  }
}
