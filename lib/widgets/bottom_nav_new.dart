import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
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
                // open lotus screen
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
