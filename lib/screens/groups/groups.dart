import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/groups/groups_appbar.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav_new.dart';
import 'package:junto_beta_mobile/screens/spheres/spheres.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/backend/mock/mock_packs.dart';
import 'package:junto_beta_mobile/models/models.dart';

class JuntoGroups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoGroupsState();
  }
}

class JuntoGroupsState extends State<JuntoGroups> {
  int _currentIndex = 0;
  PageController _groupsController;

  @override
  void initState() {
    super.initState();
    _groupsController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _groupsController.dispose();
  }

  List<Group> _packs = MockPackService().packs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: JuntoGroupsAppbar(),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: BottomNavNew(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).dividerColor, width: .5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _groupsController.jumpToPage(0);
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width * .5,
                        margin: EdgeInsets.only(right: 24),
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(CustomIcons.spheres,
                                size: 18,
                                color: _currentIndex == 0
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).primaryColorLight),
                            const SizedBox(width: 8),
                            Text('Spheres',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _currentIndex == 0
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(context).primaryColorLight))
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _groupsController.jumpToPage(1);
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width * .5,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(CustomIcons.packs,
                                size: 16,
                                color: _currentIndex == 1
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).primaryColorLight),
                            const SizedBox(width: 8),
                            Text('Packs',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _currentIndex == 1
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(context).primaryColorLight))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _groupsController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: <Widget>[
                    Center(
                      child: Text('helloos'),
                    ),
                    JuntoPacks()
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
