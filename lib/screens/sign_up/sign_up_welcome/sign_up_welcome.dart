
import 'package:flutter/material.dart';

import '../../collective/collective.dart';
import '../../../typography/palette.dart';

class SignUpWelcome extends StatefulWidget {
  final firstName;
  final lastName;
  final username;
  final password;
  final bio;
  final profilePicture;

  SignUpWelcome(
    this.firstName, this.lastName, this.username, 
    this.password, this.bio, this.profilePicture);

  @override
  State<StatefulWidget> createState() {

    return SignUpWelcomeState();
  }

}

class SignUpWelcomeState extends State<SignUpWelcome> {

  @override
  void initState() {
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: 
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: 
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .15,
                  bottom: MediaQuery.of(context).size.height * .15),
                child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Column(
                        children: <Widget>[  
                          Container(
                            margin: EdgeInsets.only(bottom: 40),
                            child: Image.asset('assets/images/junto-mobile__outlinelogo--gradient.png',
                            height: 69)
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            margin: EdgeInsets.only(bottom: 40),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: Color(0xffeeeeee),
                              ))
                            )
                          ),    

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .10),
                            margin: EdgeInsets.only(bottom: 40),
                            child: Text('Hey ' + widget.firstName + 
                            '! We are stoked to have you here.'
                            ,style: TextStyle(color: JuntoPalette.juntoGrey, fontWeight: FontWeight.w700, fontSize: 22
                            ), textAlign: TextAlign.center,                                  
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            margin: EdgeInsets.only(bottom: 40),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: Color(0xffeeeeee),
                              ))
                            )
                          ),                 

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .10),
                            child: Text('Junto is a community of individuals working together to inspire authenticity and meaningful collaboration.'                        
                            , style: TextStyle(color: JuntoPalette.juntoGrey, fontSize: 17,), 
                            textAlign: TextAlign.center,),
                          ),   
                      ],),
       
                        Container(
                          width: 200,
                          child:     
                            RaisedButton(                                        
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => JuntoCollective()
                                ));
                              },  
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20
                              ),            

                              color: Color(0xff4968BF),
                              child: Text('LET\'S GO!', 
                                style: TextStyle(
                                  // color: JuntoPalette.juntoBlue, 
                                  color: Colors.white, 
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                            )                                           
                        )                                  
                  ],)
              )
          ),                            
    );      
  }
}