
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/scoped_user.dart';
import './notifications_appbar/notifications_appbar.dart';

class JuntoNotifications extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
      ScopedModelDescendant<ScopedUser>(      
        builder: (context, child, model) => Scaffold(   
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: NotificationsAppbar()),
          body: SizedBox()
      )
    );
  }

}