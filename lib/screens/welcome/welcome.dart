
import 'package:flutter/material.dart';

import '../../typography/palette.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 120, bottom: 17),
                  child: Image.asset('assets/images/junto-mobile__logo--white.png', height: 69)
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 45),
                  child: Text('JUNTO', style: TextStyle(letterSpacing: 1.7 ,color: Colors.white, fontSize: 45, fontWeight: FontWeight.w500))
                ),

                // Container(
                //   margin: EdgeInsets.only(bottom: 240),
                //   child: Text('a movement for authenticity', style: TextStyle(color: Colors.white, fontSize: 20))
                // ),   
              ]
            ),
            
            Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: RaisedButton(                      
                  onPressed: () {},  
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20
                  ),                        
                  // color: Colors.white,  
                  color: Color(0xff4968BF),
                  child: Text('WELCOME TO THE PACK', 
                    style: TextStyle(
                      // color: JuntoPalette.juntoBlue, 
                      color: Colors.white, 
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                )
              ),

              Container(
                margin: EdgeInsets.only(bottom: 120),
                child: Text('SIGN IN', style: TextStyle(color: Colors.white, fontSize: 14))
              ),    

            ],)
            
         

          
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 45),
            //   child: 
            //     TextField(
            //       decoration: InputDecoration(
            //           enabledBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.white)
            //           ),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.white)
            //           ),
            //           labelStyle: TextStyle(color: Colors.green),
            //           hintText: 'USERNAME',
            //           hintStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
            //           fillColor: Colors.white,
            //       ),

            //       style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)

            //     )
            // ),

            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 45),
            //   child: 
            //     TextField(
            //       decoration: InputDecoration(
            //           enabledBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.white)
            //           ),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.white)
            //           ),
            //           labelStyle: TextStyle(color: Colors.green),
            //           hintText: 'PASSWORD',
            //           hintStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
            //           fillColor: Colors.white,
            //       ),

            //       style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)

            //     )
            // ),            

            
                     
        ],)


      )
    );
  }
}