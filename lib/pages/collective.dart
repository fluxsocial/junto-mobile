
import 'package:flutter/material.dart';

import './../custom_icons.dart';
import './../components/bottom_nav.dart';

class JuntoCollective extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:       
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: 
                Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/images/junto-mobile__logo--collective.png',
                        height: 24.0, 
                        width: 24.0),
                      
                    Container(
                        margin: EdgeInsets.only(left: 10.0),  
                        child: Text(
                          'JUNTO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3),
                        )),
                  ],
                ),

            actions: <Widget>[
              IconButton(
                icon: Icon(CustomIcons.moon),
                color: Colors.black,
                tooltip: 'open notifcations',
                onPressed: () {
                  // ...
                },
              ),
            ],
          ),
        

        body: 
          Column(children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: Colors.lightBlue)))
              ),

              Container(
                width: 1000,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                foregroundDecoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'COLLECTIVE',
                      style: TextStyle(fontWeight: FontWeight.w600) ), 
                    
                    IconButton(icon: Icon(Icons.arrow_right))
                    ])
                ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                width: 1000,
                color: Colors.white,
                foregroundDecoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: Colors.grey))),
                child: 
                  Row(children:[
                    IconButton(
                      color: Colors.blue,
                      alignment: Alignment(-1.0, 0),
                      icon: Icon(Icons.search), 
                      padding:EdgeInsets.all(0.0),

                    ),

                    Text(
                      'filter by channel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      )
                    )
                    ]
              ))
            ],),

          bottomNavigationBar: BottomNav()
          );
    }
}
