
import 'package:flutter/material.dart';

import '../../components/bottom_nav/bottom_nav_create.dart';

class JuntoCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
    Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      body: 

      Center(child:
        RaisedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text('Home')
        )
      ),

      bottomNavigationBar: BottomNavCreate(),
    );
  }
} 