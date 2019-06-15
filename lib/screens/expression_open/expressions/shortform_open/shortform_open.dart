import 'package:flutter/material.dart';

class ShortformOpen extends StatelessWidget {
  final shortformExpression;

  ShortformOpen(this.shortformExpression);

  @override
  Widget build(BuildContext context) {
    return 
    
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.9],
              colors: [
                Color(0xff5E54D0),
                Color(0xff307FAB)
              ]
            )
          ),

          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * .3,
          ),
          width: 1000,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[                
              Text(
                shortformExpression.shortformText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ); 
  }
}
