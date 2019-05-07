
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent
      // ),
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

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: 
                    TextField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          labelStyle: TextStyle(color: Colors.green),
                          hintText: 'USERNAME',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                      ),

                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)

                    )
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: 
                    TextField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          labelStyle: TextStyle(color: Colors.green),
                          hintText: 'PASSWORD',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                      ),

                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)

                    )
                ),                                                
            ],)


          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          )
        ])
    
    );      
  }
}