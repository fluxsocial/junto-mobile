import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/pending/pending_pack_members.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/pending/pending_connections.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';

class PendingRelationships extends StatefulWidget {
  PendingRelationships({
    this.userAddress,
    this.refreshActions,
  });

  final String userAddress;
  final Function refreshActions;

  @override
  State<StatefulWidget> createState() {
    return PendingRelationshipsState();
  }
}

class PendingRelationshipsState extends State<PendingRelationships> {
  final List<String> _tabs = <String>['CONNECTION REQUESTS', 'PACK REQUESTS'];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: Scaffold(
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
                    onTap: () {
                      Navigator.pop(context);
                      widget.refreshActions();
                    },
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
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
            body: TabBarView(children: <Widget>[
              PendingConnections(),
              PendingPackMembers(),
            ]),
          ),
        ),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<GroupBloc>(
        create: (ctx) => GroupBloc(
          Provider.of<GroupRepo>(ctx, listen: false),
          Provider.of<UserDataProvider>(ctx, listen: false),
          Provider.of<NotificationRepo>(ctx, listen: false),
        )..add(
            FetchMyPack(),
          ),
      ),
    ];
  }
}
