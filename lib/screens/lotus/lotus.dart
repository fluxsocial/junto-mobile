import 'package:flutter/material.dart';

class JuntoLotus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child:
              Image.asset('assets/images/junto-mobile__background--lotus.png'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 50, left: 50),
            height: 50,
            width: 50,
            child: const Text('back'),
          ),
        )
      ]),
    );
  }
}
