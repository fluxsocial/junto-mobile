import 'package:flutter/material.dart';

import './member_appbar/member_appbar.dart';

class JuntoMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: MemberAppbar(
              'sunyata'),
        ),  

      body: ListView(children: [
        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              // Den cover photo
              Container(
                height: 150.0,
                width: 1000,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/junto-mobile__den--photo.png'),
                        fit: BoxFit.cover)),

                child: Transform.translate(
                  offset: Offset(0, 120),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__eric.png',
                                height: 60.0,
                                width: 60.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                  color: Colors.transparent,
                  height: 30,
                  width: MediaQuery.of(context).size.width),

              Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ERIC YANG',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700)),
                                Text('sunyata',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ))
                              ]),

                          Row(children: <Widget>[
                              GestureDetector(
                                onTap: () {},
                                child:  
                                  Container(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(border: Border.all(color: Color(0xff555555), width: 1), borderRadius: BorderRadius.circular(2)),                               
                                      child: Text('FOLLOW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                                    ),
                              ),

                              GestureDetector(
                                onTap: () {},
                                child: 
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(border: Border.all(color: Color(0xff555555), width: 1), borderRadius: BorderRadius.circular(2)),                               
                                    child: Text('JOIN PACK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                                  ),                                    
                              )                      
                          ],)

                       
                        ]),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      // color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                          'To a mind that is still, the whole universe surrenders - Lao Tzu. Houston-raised, NYC based. ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ))),
                  Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Container(
                            child: Text('EXPRESSIONS',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff333333)))),

                        // Container(
                        //   child: Text('JOURNAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff777777)))
                        // ),

                        // Container(
                        //   child: Text('FAVORITES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff777777)))
                        // ),

                        // Container(
                        //   child: Text('DRAFTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff777777)))
                        // ),
                      ])),






                ]),
              ),
            ],
          ),
        ),
      ]),

      // Bottom nav widget
      // bottomNavigationBar: BottomNav(),
    );
  }
}
