import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:provider/provider.dart';

class EditPerspectiveAddMembers extends StatefulWidget {
  const EditPerspectiveAddMembers(
      {this.perspective, this.refreshPerspectiveMembers});

  final CentralizedPerspective perspective;
  final Function refreshPerspectiveMembers;

  @override
  State<StatefulWidget> createState() {
    return EditPerspectiveAddMembersState();
  }
}

class EditPerspectiveAddMembersState extends State<EditPerspectiveAddMembers>
    with ListDistinct {
  final List<String> _tabs = <String>['Subscriptions', 'Connections'];
  final List<String> _perspectiveMembers = <String>[];

  final AsyncMemoizer<Map<String, dynamic>> _memoizer =
      AsyncMemoizer<Map<String, dynamic>>();

  Future<Map<String, dynamic>> getUserRelationships() async {
    return _memoizer.runOnce(
      () => Provider.of<UserRepo>(context, listen: false).userRelations(),
    );
  }

  Future<void> addMembersToPerspective() async {
    if (_perspectiveMembers.isNotEmpty) {
      JuntoLoader.showLoader(context);
      print(_perspectiveMembers);
      try {
        await Provider.of<UserRepo>(context, listen: false)
            .addUsersToPerspective(
                widget.perspective.address, _perspectiveMembers);
        Navigator.pop(context);
        widget.refreshPerspectiveMembers();
        JuntoLoader.hide();
      } catch (error) {
        print(error);
        JuntoLoader.hide();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // print(widget.existingMembers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            titleSpacing: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: .75,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).dividerColor,
              ),
            ),
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Icon(CustomIcons.back, size: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addMembersToPerspective();
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).primaryColor),
                        )),
                  ),
                ],
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
                      labelStyle: Theme.of(context).textTheme.subtitle1,
                      indicatorWeight: 0.0001,
                      tabs: <Widget>[
                        for (String name in _tabs)
                          Container(
                            margin: const EdgeInsets.only(right: 24),
                            color: Theme.of(context).colorScheme.background,
                            child: Tab(
                              text: name,
                            ),
                          ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: FutureBuilder<Map<String, dynamic>>(
              future: getUserRelationships(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  // get list of connections
                  final List<UserProfile> _connectionsMembers =
                      snapshot.data['connections']['results'];

                  // get list of following
                  final List<UserProfile> _followingMembers =
                      snapshot.data['following']['results'];

                  return TabBarView(
                    children: <Widget>[
                      // subscriptions
                      ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: _followingMembers
                            .map(
                              (dynamic connection) => MemberPreviewSelect(
                                profile: connection,
                                onSelect: () {
                                  _perspectiveMembers.add(connection.address);
                                },
                                onDeselect: () {
                                  _perspectiveMembers
                                      .indexWhere(connection.addres);
                                  _perspectiveMembers
                                      .remove(connection.address);
                                },
                              ),
                            )
                            .toList(),
                      ),
                      // connections
                      ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: _connectionsMembers
                            .map(
                              (dynamic connection) => MemberPreviewSelect(
                                profile: connection,
                                onSelect: () {
                                  _perspectiveMembers.add(connection.address);
                                },
                                onDeselect: () {
                                  _perspectiveMembers
                                      .remove(connection.address);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return TabBarView(
                    children: <Widget>[
                      Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, -50),
                          child: Text('Hmmm, something is up',
                              style: Theme.of(context).textTheme.caption),
                        ),
                      ),
                      Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, -50),
                          child: Text('Hmmm, something is up',
                              style: Theme.of(context).textTheme.caption),
                        ),
                      ),
                    ],
                  );
                }
                return TabBarView(
                  children: <Widget>[
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator(),
                      ),
                    ),
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
