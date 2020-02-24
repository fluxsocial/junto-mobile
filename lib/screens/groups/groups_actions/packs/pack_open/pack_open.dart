import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/repositories/group_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackOpen extends StatefulWidget {
  const PackOpen({
    Key key,
    @required this.pack,
  }) : super(key: key);

  final Group pack;

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  //ignore:unused_field
  String _userAddress;
  UserData _userProfile;

  // Controller for PageView
  PageController controller;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    getUserInformation();
  }

  final AsyncMemoizer<List<CentralizedExpressionResponse>> _memoizer =
      AsyncMemoizer<List<CentralizedExpressionResponse>>();

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<List<CentralizedExpressionResponse>> getPackExpressions() async {
    return _memoizer.runOnce(
      () => Provider.of<GroupRepo>(context).getGroupExpressions(
        _userProfile.pack.address,
        GroupExpressionQueryParams(
            creatorExpressions: true,
            directExpressions: true,
            directExpressionPaginationPosition: 0,
            creatorExpressionsPaginationPosition: 0),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: PackOpenAppbar(pack: widget.pack),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _isVisible,
          builder: (BuildContext context, bool visible, Widget child) {
            return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: visible ? 1.0 : 0.0,
                child: child);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: BottomNav(
                actionsVisible: false,
                screen: 'collective',
                userProfile: _userProfile,
                onTap: () {}),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: <Widget>[
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //   decoration: BoxDecoration(
            //     border: Border(
            //       bottom: BorderSide(
            //           color: Theme.of(context).dividerColor, width: .75),
            //     ),
            //   ),
            //   child: Row(
            //     children: <Widget>[
            //       GestureDetector(
            //         onTap: () => controller.jumpToPage(0),
            //         child: Container(
            //           color: Colors.transparent,
            //           child: Text(
            //             'Public',
            //             style: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.w700,
            //               color: _currentIndex == 0
            //                   ? Theme.of(context).primaryColor
            //                   : Theme.of(context).primaryColorLight,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 25),
            //       GestureDetector(
            //         onTap: () {
            //           controller.jumpToPage(1);
            //         },
            //         child: Container(
            //             color: Colors.transparent,
            //             child: Text(
            //               'Private',
            //               style: TextStyle(
            //                 fontSize: 15,
            //                 fontWeight: FontWeight.w700,
            //                 color: _currentIndex == 1
            //                     ? Theme.of(context).primaryColor
            //                     : Theme.of(context).primaryColorLight,
            //               ),
            //             )),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (int index) {},
                children: <Widget>[
                  if (_userProfile != null)
                    FutureBuilder<List<CentralizedExpressionResponse>>(
                      future: getPackExpressions(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CentralizedExpressionResponse>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Transform.translate(
                              offset: const Offset(0.0, -50),
                              child: const Text('Hmm, something is up'),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return ListView(
                            children: <Widget>[
                              Container(
                                color: Theme.of(context).backgroundColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 10,
                                        right: 5,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          for (int index = 0;
                                              index < snapshot.data.length + 1;
                                              index++)
                                            if (index == snapshot.data.length)
                                              const SizedBox()
                                            else if (index.isEven)
                                              ExpressionPreview(
                                                expression:
                                                    snapshot.data[index],
                                                userAddress: _userAddress,
                                              )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 5,
                                        right: 10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          for (int index = 0;
                                              index < snapshot.data.length + 1;
                                              index++)
                                            if (index == snapshot.data.length)
                                              const SizedBox()
                                            else if (index.isOdd)
                                              ExpressionPreview(
                                                expression:
                                                    snapshot.data[index],
                                                userAddress: _userAddress,
                                              )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: Transform.translate(
                            offset: const Offset(0.0, -50),
                            child: JuntoProgressIndicator(),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
