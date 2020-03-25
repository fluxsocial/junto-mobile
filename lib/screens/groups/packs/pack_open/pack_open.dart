import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/screens/groups/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:provider/provider.dart';

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
  final List<String> _tabs = <String>['Pack', 'Private', 'Members'];

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackBloc(
        Provider.of<ExpressionRepo>(context, listen: false),
        Provider.of<GroupRepo>(context, listen: false),
        widget.pack.address,
      )..add(FetchPacks(widget.pack.address)),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: PackOpenAppbar(
            pack: widget.pack,
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _isVisible,
          builder: (BuildContext context, bool visible, Widget child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: visible ? 1.0 : 0.0,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: BottomNav(
              actionsVisible: false,
              onLeftButtonTap: () {},
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: DefaultTabController(
          length: _tabs.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: .75,
                    ),
                  ),
                ),
                child: TabBar(
                  labelPadding: const EdgeInsets.all(0),
                  isScrollable: true,
                  labelColor: Theme.of(context).primaryColorDark,
                  unselectedLabelColor: Theme.of(context).primaryColorLight,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  indicatorWeight: 0.0001,
                  tabs: <Widget>[
                    for (String name in _tabs) PackName(name: name),
                  ],
                ),
              ),
              PackTabs(group: widget.pack),
            ],
          ),
        ),
      ),
    );
  }
}

class PackTabs extends StatefulWidget {
  const PackTabs({
    Key key,
    @required this.group,
  }) : super(key: key);

  final Group group;

  @override
  _PackTabsState createState() => _PackTabsState();
}

class _PackTabsState extends State<PackTabs> {
  bool _swipeLeftEnabled = false;
  bool _swipeRightEnabled = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    controller.addListener(() {
      setState(() {
        print('controller list');
        // _swipeLeftEnabled = controller.index == 0;
        // _swipeRightEnabled = controller.index == 2;
      });
    });
  }

  void _leftDrawer(bool value) {
    setState(() {
      print(value);
      _swipeLeftEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollNotification>(
        onNotification: (value) {
          if (value.overscroll < 0) {
            JuntoFilterDrawer.of(context).toggle();
            // _leftDrawer(true);
          } else if (value.overscroll > 0) {
            JuntoFilterDrawer.of(context).toggleRightMenu();
            // _leftDrawer(false);
          }
          // Future.delayed(Duration(milliseconds: 1200)).then((value) {
          //   _leftDrawer(false);
          // });
          // value.dispatch(context);
        },
        child: TabBarView(
          physics: _swipeLeftEnabled
              ? NeverScrollableScrollPhysics()
              : PageScrollPhysics(),
          children: <Widget>[
            GroupExpressions(
              key: const PageStorageKey<String>('public-pack'),
              group: widget.group,
              privacy: 'Public',
            ),
            GroupExpressions(
              key: const PageStorageKey<String>('private-pack'),
              group: widget.group,
              privacy: 'Private',
            ),
            PackOpenMembers(
              key: UniqueKey(),
              packAddress: widget.group.address,
            )
          ],
        ),
      ),
    );
  }
}

class PackName extends StatelessWidget {
  const PackName({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(right: 20),
      child: Text(
        name.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
