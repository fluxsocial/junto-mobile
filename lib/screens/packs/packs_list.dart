import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/my_packs.dart';
import 'package:junto_beta_mobile/screens/packs/pack_requests.dart';

class PacksList extends StatefulWidget {
  const PacksList({this.selectedGroup});

  final ValueChanged<Group> selectedGroup;

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
                  MyPacks(selectedGroup: widget.selectedGroup),
                  PackRequests(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
