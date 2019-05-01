
import 'package:flutter/material.dart';

import '../../components/appbar/appbar.dart';
import '../../components/bottom_nav/bottom_nav.dart';
import '../../components/filter/filter_perspectives/filter_perspectives.dart';
import '../../models/perspective.dart';
import './perspective_preview.dart';
import './../../typography/palette.dart';

class JuntoPerspectives extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JuntoPerspectivesState();
  }
}

class _JuntoPerspectivesState extends State {

  List perspectives;

  @override
  void initState() {
    super.initState();

    perspectives = Perspective.fetchAll();
  }

  @override
  Widget build(BuildContext context) {  

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--den.png', 'PERSPECTIVES', JuntoPalette.juntoGrey),

        body: ListView(
          children: <Widget>[        
            Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: 
                Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Create a perspective', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: JuntoPalette.juntoGrey)),
                  Container(
                    child: Icon(Icons.add_circle_outline, size: 17, color: JuntoPalette.juntoGrey)
                  )
                ],
              )
            ),

            ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children:               
                perspectives.map((perspective) => 
                PerspectivePreview(perspective.perspectiveTitle)).toList(),
            )                          
          ],
        ),

        bottomNavigationBar: BottomNav(),
    );
  }
}
