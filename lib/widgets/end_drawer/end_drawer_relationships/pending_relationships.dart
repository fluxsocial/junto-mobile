import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/relationship_request.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:provider/provider.dart';

class PendingRelationships extends StatefulWidget {
  PendingRelationships({
    this.refreshActions,
  });

  Function refreshActions;

  @override
  State<StatefulWidget> createState() {
    return PendingRelationshipsState();
  }
}

class PendingRelationshipsState extends State<PendingRelationships> {
  Future<dynamic> _userRelations;
  final List<String> _tabs = <String>['CONNECTION REQUESTS', 'PACK REQUESTS'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userRelations = getUserRelationships();
  }

  Future<dynamic> getUserRelationships() async {
    return await Provider.of<UserRepo>(context, listen: false).userRelations();
  }

  void _refreshActions(bool action) {
    setState(() {
      _userRelations = getUserRelationships();
    });
    widget.refreshActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                delegate: JuntoAppBarDelegate(
                  TabBar(
                    labelPadding: const EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColorDark,
                    unselectedLabelColor: Theme.of(context).primaryColorLight,
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    indicatorWeight: 0.0001,
                    tabs: <Widget>[
                      for (String name in _tabs)
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          color: Theme.of(context).colorScheme.background,
                          child: Tab(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: FutureBuilder<dynamic>(
            future: _userRelations,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                // get list of connections
                final List<UserProfile> _connectionRequests =
                    snapshot.data['pending_connections']['results'];

                // get list of following
                final List<UserProfile> _packRequests =
                    snapshot.data['pending_group_join_requests']['results'];

                return TabBarView(
                  children: <Widget>[
                    // connection requsts
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _connectionRequests
                          .map(
                            (dynamic request) =>
                                RelationshipRequest(request, _refreshActions),
                          )
                          .toList(),
                    ),

                    // todo: waiting on API fix - pending pack requests
                    const SizedBox()
                  ],
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const TabBarView(
                  children: <Widget>[
                    JuntoErrorWidget(
                        errorMessage: 'Hmm, something went wrong'),
                    JuntoErrorWidget(
                        errorMessage: 'Hmm, something went wrong'),
                  ],
                );
              }
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: JuntoProgressIndicator(),
                  ),
                  Center(
                    child: JuntoProgressIndicator(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
