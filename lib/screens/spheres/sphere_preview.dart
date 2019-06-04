import 'package:flutter/material.dart';

class SpherePreview extends StatelessWidget {
  final String sphereTitle;
  final String sphereMembers;

  SpherePreview(this.sphereTitle, this.sphereMembers);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffeeeeee), width: 1),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Color(0xffeeeeee),
            blurRadius: 3,
            offset: Offset(1, 3),
            // spreadRadius: 5
          )
        ],
      ),

      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Container(
            
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/junto-mobile__den--photo.png'),
              //   fit: BoxFit.cover
              // ),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.9],
                colors: [
                  Colors.green,
                  Colors.lightGreen
                ]
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffeeeeee),
                  blurRadius: 2,
                  offset: Offset(1, 2),
                )
              ],
            ),
            height: 140,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      sphereTitle,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ),

                  Container(
                    child: Text(sphereMembers + ' MEMBERS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, ))
                  )
                ],
              ))
        ],
      ),
    );
  }
}
