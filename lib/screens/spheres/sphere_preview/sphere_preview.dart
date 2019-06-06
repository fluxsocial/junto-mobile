import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

// This class renders a preview of a sphere
class SpherePreview extends StatelessWidget {
  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;

  SpherePreview(this.sphereTitle, this.sphereMembers, this.sphereImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffeeeeee), width: .25),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Color(0xffeeeeee),
            blurRadius: 3,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: sphereImage != ''
                  ? DecorationImage(
                      image: AssetImage(sphereImage), fit: BoxFit.cover)
                  : null,
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.9
                  ],
                  colors: [
                    JuntoPalette.juntoGreen,
                    JuntoPalette.juntoGreenLight
                  ]),
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
            height: MediaQuery.of(context).size.height * .2,
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
                      child: Text(sphereMembers + ' MEMBERS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )))
                ],
              ))
        ],
      ),
    );
  }
}
