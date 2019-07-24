import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/scoped_user.dart';
import './../../components/expression_preview/expression_preview.dart';

class JuntoDen extends StatefulWidget {
  final scopedUser;

  JuntoDen(this.scopedUser);

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
                              ScopedModelDescendant<ScopedUser>(
                                  builder: (context, child, model) {
                                return Text(
                                    model.firstName + ' ' + model.lastName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700));
                              }),
                              ScopedModelDescendant<ScopedUser>(
                                  builder: (context, child, model) =>
                                      Text(model.username,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )))
                            ]),
                        Icon(Icons.edit, size: 14)
                      ]),
                ),
                ScopedModelDescendant<ScopedUser>(
                  builder: (context, child, model) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      // color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      child: Text(model.bio,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ))),
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xffeeeeee), width: 1))),
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
    ]);
  }
}
