
import 'package:flutter/material.dart';

import '../sign_up_four/sign_up_four.dart';

class SignUpThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.1, 0.9],
                colors: [
                  Color(0xff5E54D0),
                  Color(0xff307FAB)
                ]
              )
            ),

            child: 
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .10 + 18),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: 
                  Column(      
                    crossAxisAlignment: CrossAxisAlignment.start,        
                    children: <Widget> [
                      Container(                
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .17),
                        child: Text('Create a password. Make sure it is secure!',
                          style: TextStyle(color: Colors.white, fontSize: 27)
                        )
                      ),   

                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 36),
                              child: 
                                TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)
                                      ),
                                      labelStyle: TextStyle(color: Colors.green),
                                      hintText: 'PASSWORD',
                                      hintStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                      fillColor: Colors.white,
                                  ),
                                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)
                                )
                            ),
                          ]
                        )
                      )                
                  ],)
              )
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * .05,
            left: 20,
            child: Image.asset(
              'assets/images/junto-mobile__logo--white.png',
              height: 36,
              )
          ), 

          Positioned(
            bottom: MediaQuery.of(context).size.height * .05,
            right: 20,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 17),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_left, color: Colors.white, size: 27),
                    ),
                ),
              
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SignUpFour()
                    ));
                  },
                  child: Icon(Icons.arrow_right, color: Colors.white, size: 22),
                ),                
              ],
            )
          ),                            
        ])
    
    );      
  }
}