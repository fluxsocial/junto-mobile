import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';

// This screen displays the temporary page we'll display until groups are released
class SpheresTemp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: null,
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              brightness: Theme.of(context).brightness,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Groups',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  IconButton(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(0),
                    color: Colors.green,
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      size: 0,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: BottomNav(
              address: null,
              expressionContext: ExpressionContext.Group,
              actionsVisible: false,
              onLeftButtonTap: () {},
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'Groups are public, private, or secret communities you can create within Junto. We will open this layer once enough members are on-boarded to make this feature useful.',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
