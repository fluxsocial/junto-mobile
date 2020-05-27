import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/packs/my_packs.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_actions_button.dart';
import 'package:junto_beta_mobile/screens/packs/packs_list_appbar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_requests.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';

class PacksList extends StatefulWidget {
  const PacksList({this.packsViewNav, this.isVisible});

  final Function packsViewNav;
  final ValueNotifier<bool> isVisible;

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

  void _packsListNav() {
    setState(() {
      if (_currentIndex == 0) {
        packsListController.nextPage(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 300),
        );
      } else {
        packsListController.previousPage(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: null,
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * .1 + 50,
            ),
            child: PacksListAppBar(
              currentIndex: _currentIndex,
              packsListNav: _packsListNav,
            ),
          ),
          floatingActionButton: PacksActionButtons(
            isVisible: widget.isVisible,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: PageView(
                    controller: packsListController,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: <Widget>[
                      MyPacks(
                        packsViewNav: widget.packsViewNav,
                      ),
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
