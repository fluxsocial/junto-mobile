import 'package:flutter/material.dart';

import '../member/member.dart';

class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return JuntoDenState();
  }
}

class JuntoDenState extends State<JuntoDen> {
  void noNav() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            // Den cover photo
            Container(
              constraints: BoxConstraints.expand(
                height: 150
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/junto-mobile__stillmind.png'),
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
                                    Text(
                                    'Eric Yang',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700)
                              ),
                                
                                    Text('sunyata',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ))
                            ]),
                        Icon(Icons.edit, size: 14)
                      ]),
                ),
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                      width: MediaQuery.of(context).size.width,
                      child: Text('to a mind that is still, the whole universe surrenders',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ))),


                        RaisedButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => JuntoMember()));
                          }
                        )
                        

              ]),
            ),
          ],
        ),
      ), 
    ]);
  }
}
