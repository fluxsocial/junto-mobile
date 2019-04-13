
import 'package:flutter/material.dart';

class PreviewBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
        Container(
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                child: Text('channel one'),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                child: Text('res placeholder'),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                child: Text('comment placeholder'),
              ),

      
            ],
          ),
        );    
  }

}