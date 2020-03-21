import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
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
  UserData _userProfile;
  final List<String> _tabs = <String>['Pack', 'Private', 'Members'];

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProfile =
        Provider.of<UserDataProvider>(context, listen: false).userProfile;
  }

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
            userProfile: _userProfile,
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
                    for (String name in _tabs)
                      Container(
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(right: 20),
                        child: Text(
                          name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    GroupExpressions(
                      key: const PageStorageKey<String>('public-pack'),
                      group: widget.pack,
                      privacy: 'Public',
                    ),
                    GroupExpressions(
                      key: const PageStorageKey<String>('private-pack'),
                      group: widget.pack,
                      privacy: 'Private',
                    ),
                    PackOpenMembers(
                      key: UniqueKey(),
                      packAddress: widget.pack.address,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
