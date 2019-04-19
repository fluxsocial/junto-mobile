
import 'package:flutter/material.dart';

import '../../components/bottom_nav/bottom_nav.dart';

class Create extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('create')),
      bottomNavigationBar: BottomNav(),

    );
  }
}