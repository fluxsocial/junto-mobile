
import 'package:flutter/material.dart';

import '../../custom_icons.dart';

class CommentPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__riley.png',
                  height: 36.0,
                  width: 36.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: .5))
                  ),                          
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 66,
                        child: 
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Text('Riley Wagner', style: TextStyle(fontWeight: FontWeight.w700)),
                                SizedBox(width: 5),
                                Text('ryewags'),
                              ],),

                              Icon(CustomIcons.more, size: 20)

                            ],
                          ),                                  
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: MediaQuery.of(context).size.width - 66,
                        child: Text(
                            'Hi this is a comment preview',
                            style: TextStyle(fontSize: 15)),
                      ),

                      Container(
                        child: Text('5 MINUTES AGO', style: TextStyle(fontSize: 10, color: Color(0xff555555)))
                      )
                    ],
                  ))
            ],
          ));    
  }
}