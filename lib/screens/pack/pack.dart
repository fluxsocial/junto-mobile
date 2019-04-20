
import 'package:flutter/material.dart';

// typography
import './../../typography/palette.dart';

// appbar + bottom nav
import '../../components/appbar/appbar.dart';
import '../../components/appbar/appbar_border/appbar_border.dart';
import './../../components/bottom_nav/bottom_nav.dart';

// pack preview + model
import '../../models/pack.dart';
import './pack_preview.dart';
import '../../components/filter/filter_packs/filter_packs.dart';


class JuntoPack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _JuntoPackState();
  }
}

class _JuntoPackState extends State {
  List packs;

  @override
  void initState() {
    super.initState();

    packs = Pack.fetchPack();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--pack.png', 'PACKS'),

        body: Column(
          children: <Widget>[
            
            // App bar border
            AppbarBorder(JuntoPalette.juntoPurple),

            // My Pack
            Container(
              height: 90.0,
              padding: EdgeInsets.symmetric(horizontal: 17.0),
              color: Colors.white,
              foregroundDecoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
                ),
              ),              
              child: Row(
                children: <Widget>[
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(                                                                        
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            height: 36.0,
                            width: 36.0,
                            fit: BoxFit.cover,
                            
                          ),
                        ),                    

                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('The Gnarly Nomads', textAlign: TextAlign.start,),
                            Text('Eric Yang', textAlign: TextAlign.start,)
                          ],
                        ),)
                  ],),

                ],
              )

            ),

                // Search packs text field
            FilterPacks(),

            Expanded(
              child: ListView(
                children: packs.map((pack) => PackPreview(pack.packTitle, pack.packUser)).toList()
              )
            )       
            
          ],
        ),
        bottomNavigationBar: BottomNav());
  }
}
