
import 'package:flutter/material.dart';
import '../../../typography/palette.dart';

class CollectiveFilterFAB extends StatelessWidget {
  final isVisible;
  final toggleFilter;

  CollectiveFilterFAB(this.isVisible, this.toggleFilter);
  @override
  Widget build(BuildContext context) {

    return 
      AnimatedOpacity(                                      
        duration: Duration(milliseconds: 200),          
        opacity: isVisible ? 1 : 0,
        child: GestureDetector(
          onTap: () {
            toggleFilter(context);                        
          },
          child: 
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [
                    0.1,
                    0.9
                  ],
                  colors: [
                    JuntoPalette.juntoPurple,
                    JuntoPalette.juntoBlue
                  ]),
              color: Colors.white.withOpacity(.7),
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text('#',
                style: TextStyle(color: Color(0xffffffff)))),
      ));    
  }
}