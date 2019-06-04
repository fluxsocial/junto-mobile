
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/scoped_user.dart';

class JuntoNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      ScopedModelDescendant<ScopedUser>(      
        builder: (context, child, model) => Scaffold(   
          appBar: AppBar(), 
          body: Center(child: Column(children: [Text('NOTIFICATIONS'), RaisedButton(onPressed: () {
            Navigator.pop(context);
          },)]))
      )
    );
  }

}