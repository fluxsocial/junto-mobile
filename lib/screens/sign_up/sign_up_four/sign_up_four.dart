
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


import './../sign_up_logo/sign_up_logo.dart';
import './../sign_up_welcome/sign_up_welcome.dart';
import './../../../scoped_models/scoped_user.dart';

class SignUpFour extends StatefulWidget {
  final firstName;
  final lastName;
  final username;
  final password;

  SignUpFour(this.firstName, this.lastName, this.username, this.password);

  @override
  State<StatefulWidget> createState() {

    return SignUpFourState();
  }
}

class SignUpFourState extends State<SignUpFour> {
  static TextEditingController bioController = TextEditingController();
  var bio = '';
  var profilePicture = '';

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
                        child: Text('We are almost done! Feel free to upload a photo and write a brief bio of who you are',
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
                                  controller: bioController,
                                  onChanged: (text) {
                                    setState(() {
                                      bio = text;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,                 
                                      labelStyle: TextStyle(color: Colors.green),
                                      hintText: 'A LITTLE BIT ABOUT MYSELF...',
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

          SignUpLogo(),


          ScopedModelDescendant<ScopedUser> (
            builder: (context, child, model) =>
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
                        bioController.text = '';

                        if(widget.firstName != '' && widget.lastName != '' && 
                        widget.username != '' && widget.password != '') {    

                          model.setFirstName(widget.firstName);
                          model.setLastName(widget.lastName);
                          model.setUsername(widget.username);
                          model.setPassword(widget.password);
                          model.setBio(bio);
                          model.setProfilePicture(profilePicture);

                          model.setCollectiveExpressions();

                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => SignUpWelcome(widget.firstName, 
                            widget.lastName, widget.username, widget.password, bio, profilePicture)
                          ));
                        }
                      },
                      child: Icon(Icons.arrow_right, color: Colors.white, size: 22),
                    ),                ],
                )
              ),  
          )                          
        ])
    
    );      
  }
}