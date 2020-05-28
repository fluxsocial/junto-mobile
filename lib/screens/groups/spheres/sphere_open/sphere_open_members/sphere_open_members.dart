import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';

class SphereOpenMembers extends StatefulWidget {
  const SphereOpenMembers({
    Key key,
    @required this.users,
    @required this.group,
  }) : super(key: key);

  final List<Users> users;
  final Group group;

  static Route<dynamic> route(Group group, List<Users> users) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return SphereOpenMembers(
          users: users,
          group: group,
        );
      },
    );
  }

  @override
  _SphereOpenMembersState createState() => _SphereOpenMembersState();
}

class _SphereOpenMembersState extends State<SphereOpenMembers> {
  final List<String> _tabs = <String>['Facilitators', 'Members'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            brightness: Theme.of(context).brightness,
            elevation: 0,
            titleSpacing: 0,
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      color: Colors.transparent,
                      width: 42,
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        CustomIcons.back,
                        color: Theme.of(context).primaryColorDark,
                        size: 17,
                      ),
                    ),
                  ),
                  const SizedBox(width: 42)
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
                      width: .75,
                      color: Theme.of(context).dividerColor,
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
              body: TabBarView(
                children: <Widget>[
                  // Group facilitators (admins)
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: widget.users.map((Users user) {
                            if (user.permissionLevel == 'Admin') {
                              return MemberPreview(
                                profile: user.user,
                              );
                            }
                            return const SizedBox();
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // All group members
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: widget.users
                              .map(
                                (Users user) => MemberPreview(
                                  profile: user.user,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
