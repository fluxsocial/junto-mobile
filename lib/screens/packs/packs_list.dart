import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/packs/my_packs.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_actions_button.dart';
import 'package:junto_beta_mobile/screens/packs/pack_requests.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';

class PacksList extends StatefulWidget {
  const PacksList();

  @override
  State<StatefulWidget> createState() {
    return PacksListState();
  }
}

class PacksListState extends State<PacksList> {
  PageController packsListController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    packsListController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: null,
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Theme.of(context).backgroundColor,
            brightness: Theme.of(context).brightness,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Packs',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: PacksActionButtons(
            isVisible: ValueNotifier<bool>(true),
            actionsVisible: true,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).backgroundColor,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          packsListController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          child: Text(
                            'My Packs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _currentIndex == 0
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          packsListController.animateToPage(1,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        },
                        child: Container(
                          child: Text(
                            'Requests',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _currentIndex == 1
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: packsListController,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: <Widget>[
                      MyPacks(),
                      PackRequests(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
