import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/scoped_user.dart';

// typography + icons
import '../../custom_icons.dart';
import '../../typography/palette.dart';
import '../../typography/style.dart'; 

class JuntoAppBar {

   static getJuntoAppBar(_juntoAppBarLogo, _juntoAppBarTitle, _juntoAppBarBorder) {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.0),
      child: AppBar(
        automaticallyImplyLeading: false, 
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.5),
          child: Container(
            height: 1.5,
            color: _juntoAppBarBorder
          )
        ),
        backgroundColor: JuntoPalette.juntoWhite,
        brightness: Brightness.light,
        elevation: 0,
        titleSpacing: 0.0,
        title:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: 
              Row(              
                mainAxisAlignment: MainAxisAlignment.spaceBetween,                 
                children: [
                  Row(
                    children: <Widget>[                
                      Image.asset(_juntoAppBarLogo,
                          height: 20.0, width: 20.0),
                      Container(
                        margin: EdgeInsets.only(left: 7.5),
                        child: Text(_juntoAppBarTitle,
                            textAlign: TextAlign.center,
                            style: JuntoStyles.appbarTitle),
                      ),
                    ],
                  ),

                  Row(children: <Widget>[

                    Container(                
                      child: Icon(Icons.search, color: JuntoPalette.juntoSleek, size: 20),
                    ),

                  ScopedModelDescendant<ScopedUser>(
                      builder: (context, child, model) => 
                        Container(
                          margin: EdgeInsets.only(left: 7.5),
                          child: RaisedButton(
                            onPressed: () {
                              model.createUser('sunyata', 'urk', 'yang', 'hello', 'hellos');
                            }
                          )
                        )     
                  ),    

                  ScopedModelDescendant<ScopedUser>(
                      builder: (context, child, model) => 
                        Container(
                          margin: EdgeInsets.only(left: 7.5),
                          child: RaisedButton(
                            onPressed: () {
                              model.getDens();
                            }
                          )
                        )     
                  ),  

                  ScopedModelDescendant<ScopedUser>(
                      builder: (context, child, model) => 
                        Container(
                          margin: EdgeInsets.only(left: 7.5),
                          child: RaisedButton(
                            onPressed: () {
                              model.getPack();
                            }
                          )
                        )     
                  ),                                      

                        // Container(
                        //   margin: EdgeInsets.only(left: 7.5),
                        //   child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek, size: 20),
                        // )                                          
 
                  ],)
              ]),
          )
      ),
    );
  }
}