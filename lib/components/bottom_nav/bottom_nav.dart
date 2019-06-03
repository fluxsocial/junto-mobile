
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/scoped_user.dart';


// typography + icons
import './../../custom_icons.dart';
import './../../typography/palette.dart';
import '../../route_animations/route_main_screens/route_main_screens.dart';
import '../../screens/collective/collective.dart';
import '../../screens/spheres/spheres.dart';
import '../../screens/pack/pack.dart';
import '../../screens/den/den.dart';


class BottomNav extends StatefulWidget { 

  final _active;

  BottomNav(this._active);

  @override
  State<StatefulWidget> createState() {

    return BottomNavState();
  }
}

class BottomNavState extends State<BottomNav> {
  Color _collectiveColor = Color(0xff333333);
  Color _spheresColor = Color(0xff999999);
  Color _packColor = Color(0xff999999);
  Color _denColor = Color(0xff999999);    

  _iconColor() {
    if(widget._active == 'collective') {
      setState(() {
        _collectiveColor = Color(0xff333333);      
      });
    } else if(widget._active == 'spheres') {
      setState(() {
        _spheresColor = Color(0xff333333);      
      });
    } else if (widget._active == 'pack') {
      setState(() {
        _packColor = Color(0xff333333);      
      });
    } else if (widget._active == 'den') {
      setState(() {
        _denColor = Color(0xff333333);      
      });
    }
  }  

  _resetState() {
    _collectiveColor = Color(0xff999999);
    _spheresColor = Color(0xff999999);
    _packColor = Color(0xff999999);
    _denColor = Color(0xff999999);       
  }

  @override
  void initState() {
    _resetState();
    _iconColor();

    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xffeeeeee), width: .75),
          ),
        ),
        height: 45,
        child: 

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[            
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoCollective()));

                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: _collectiveColor),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/spheres');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoSpheres()));
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: _spheresColor),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/create');
                },
                icon: Icon(
                  CustomIcons.lotus,
                  size: 24.0,
                ),
                color: Color(0xff999999)),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/pack');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoPack()));

                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: _packColor),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/den');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoDen()));
                
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: _denColor),
          ],
        ));
  }
}
