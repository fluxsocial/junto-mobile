import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';

class PerspectivesAppbar extends StatelessWidget {
  const PerspectivesAppbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      // backgroundColor: Colors.orange,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Perspectives',
            style: Theme.of(context).textTheme.headline4,
          ),
          IconButton(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (ctx) => CreatePerspectivePage(),
                ),
              );
            },
            icon: Icon(
              Icons.add,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
