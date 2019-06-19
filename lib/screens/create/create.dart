import 'package:flutter/material.dart';

import './create_bottom_nav.dart';
import '../../typography/style.dart';
import './longform/longform.dart';
import './shortform/shortform.dart';
import './photo/photo.dart';
import './bullet/bullet.dart';
import './event/event.dart';
import './music/music.dart';
import './create_actions.dart';
import './../../typography/palette.dart';

class JuntoCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  String _expressionType = 'LONGFORM';
  bool _longform = true;
  bool _shortform = false;
  bool _bullet = false;
  bool _photo = false;
  bool _events = false;
  bool _music = false;

  bool _bottomNavVisible = true;

  _toggleBottomNavVisibility() {
    if (_bottomNavVisible) {
      setState(() {
        _bottomNavVisible = false;
      });
    } else {
      setState(() {
        _bottomNavVisible = true;
      });
    }
  }

  // Build expression template based off state
  _buildTemplate() {
    if (_longform) {
      return CreateLongform();
    } else if (_shortform) {
      return CreateShortform();
    } else if (_bullet) {
      return CreateBullet();
    } else if (_photo) {
      return CreatePhoto(_toggleBottomNavVisibility);
    } else if (_events) {
      return CreateEvent();
    } else if (_music) {
      return CreateMusic();
    }
  }

  // Reset all values in state to false
  void _resetState() {
    setState(() {
      _longform = false;
      _shortform = false;
      _bullet = false;
      _photo = false;
      _events = false;
      _music = false;
    });
  }

  // Ask for user confirmation to switch between expressions if field is not empty
  confirmSwitch() {}

  // Switch between different expression templates
  switchTemplate(templateType) {
    // Reset State
    _resetState();

    // Update expression type
    _expressionType = templateType;

    // Update state
    if (templateType == 'longform') {
      setState(() {
        _longform = true;
      });
    } else if (templateType == 'shortform') {
      setState(() {
        _shortform = true;
      });
    } else if (templateType == 'bullet') {
      setState(() {
        _bullet = true;
      });
    } else if (templateType == 'photo') {
      setState(() {
        _photo = true;
      });
    } else if (templateType == 'events') {
      setState(() {
        _events = true;
      });
    } else if (templateType == 'music') {
      setState(() {
        _music = true;
      });
    } else {
      print('not an expresion type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            padding: EdgeInsets.only(left: 10, right: 10, top: 30),
            width: MediaQuery.of(context).size.width,
            child: Text(_expressionType.toUpperCase(),
                textAlign: TextAlign.start,
                style: JuntoStyles.lotusExpressionType),
          ),

          _buildTemplate(),

          // _expressionType != 'photo' ? CreateActions() : SizedBox()
        ],
      ),
      bottomNavigationBar: CreateBottomNav(switchTemplate, _bottomNavVisible),
    );
  }
}
