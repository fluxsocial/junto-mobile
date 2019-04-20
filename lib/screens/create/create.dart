
import 'package:flutter/material.dart';

import '../../components/bottom_nav/bottom_nav.dart';

class JuntoCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('create')),
      bottomNavigationBar: BottomNav(),

    );
  }
}