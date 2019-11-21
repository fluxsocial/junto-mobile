import 'package:flutter/material.dart';

class JuntoLotus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          child:
              Image.asset('assets/images/junto-mobile__background--lotus.png'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: 50, left: 50),
            height: 50,
            width: 50,
            child: Text('back'),
          ),
        )
      ]),
    );
  }
}
