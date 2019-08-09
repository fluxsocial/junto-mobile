
import 'package:flutter/material.dart';

import './sphere_open_appbar/sphere_open_appbar.dart';
import './../../../components/create_fab/create_fab.dart';

class SphereOpen extends StatefulWidget {
  final sphereTitle;
  final sphereImage;
  final sphereMembers;
  final sphereHandle;
  final sphereDescription; 

  SphereOpen(this.sphereTitle, this.sphereMembers, this.sphereImage, this.sphereHandle, this.sphereDescription);

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> {
  @override
  Widget build(BuildContext context) {

    return  
      Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: SphereOpenAppbar(
              widget.sphereHandle),
        ),
        floatingActionButton: CreateFAB(widget.sphereHandle),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body:
        ListView(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: 200
              ),            
            // height: 200,
            child: Image.asset(widget.sphereImage, fit: BoxFit.cover)
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[              
              Row(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Container(child: Text(widget.sphereTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                  Container(child: Text(widget.sphereMembers + ' members', style: TextStyle(fontSize: 14))),
                ],)
              ],),

              SizedBox(height: 10),

              Container(child: Text(widget.sphereDescription, textAlign: TextAlign.start, style: TextStyle(fontSize: 14)))

            ],)
          )
        ],)
      );
  }
}