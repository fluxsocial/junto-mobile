
import 'package:flutter/material.dart';

import '../../components/bottom_nav/bottom_nav_create.dart';

import './longform.dart';

class JuntoCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
    Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      body: Longform(),

      bottomNavigationBar: BottomNavCreate(),
    );
  }
} 