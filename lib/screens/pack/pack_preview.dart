import 'package:flutter/material.dart';

class PackPreview extends StatelessWidget {
  final String packTitle;
  final String packUser;

  PackPreview(this.packTitle, this.packUser);

  @override
  Widget build(BuildContext context) {
    return
        Container(
            margin: EdgeInsets.only(left: 10.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 65,
                      padding: EdgeInsets.symmetric(vertical: 20),

                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: .5, color: Color(0xffeeeeee)),
                        ),
                      ),                      
                      margin: EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(packTitle,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.w700)),
                          Text(
                            packUser,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ));
  }
}
