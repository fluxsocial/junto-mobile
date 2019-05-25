
import 'package:flutter/material.dart';

import '../../components/bottom_nav/bottom_nav_create.dart';
import './longform.dart'; 

class JuntoCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  bool _longform = true;
  bool _shortform = false;
  bool _bullet = false;
  bool _photo = false;
  bool _events = false;
  bool _music = false;

  // Build expression template based off state
  _buildTemplate() {
    if(_longform) {
      return Longform();
    } else if (_shortform) {
      return Center(child: Text('shortform'));
    } else if(_bullet) {
      return Center(child: Text('bullet'));
    } else if (_photo) {
      return Center(child: Text('photo'));
    } else if(_events) {
      return Center(child: Text('events'));
    } else if(_music) {
      return Center(child: Text('music'));
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

  // Switch between different expression templates
  switchTemplate(templateType) {
    _resetState();

  if(templateType == 'longform') {    
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

    return 
    Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      body: _buildTemplate(),

      bottomNavigationBar: BottomNavCreate(switchTemplate),
    );
  }
} 