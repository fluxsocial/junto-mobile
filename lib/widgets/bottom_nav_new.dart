import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';

import 'package:junto_beta_mobile/widgets/fabs/filter_channel_fab.dart';

class BottomNavNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).backgroundColor,
          // border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor,
              blurRadius: 3,
              spreadRadius: 2,
              // offset: Offset(2, 2),
            )
          ]),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return FilterChannelModal();
                    });
              },
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  // color: Colors.orange,
                ),
                child: Icon(CustomIcons.hash,
                    size: 17, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return JuntoLotus();
                    },
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: 400,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  // color: Colors.green,
                ),
                child: Icon(CustomIcons.lotus,
                    size: 28, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  // color: Colors.purple,
                ),
                child: Icon(CustomIcons.morevertical,
                    size: 17, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               width: 60,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 // color: Colors.orange,
//               ),
//               child: Icon(CustomIcons.hash,
//                   size: 17, color: Theme.of(context).primaryColor),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               width: 60,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 // color: Colors.green,
//               ),
//               child: Icon(CustomIcons.lotus,
//                   size: 28, color: Theme.of(context).primaryColor),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               width: 60,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 // color: Colors.purple,
//               ),
//               child: Icon(CustomIcons.morevertical,
//                   size: 17, color: Theme.of(context).primaryColor),
//             ),
//           ),

// Icon(CustomIcons.hash,
//     size: 17, color: Theme.of(context).primaryColor),
// Icon(CustomIcons.lotus,
//     size: 28, color: Theme.of(context).primaryColor),
// Icon(CustomIcons.morevertical,
//     size: 17, color: Theme.of(context).primaryColor),
