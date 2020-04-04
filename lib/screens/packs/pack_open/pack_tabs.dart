import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';

class PackTabs extends StatelessWidget {
  const PackTabs({
    Key key,
    @required this.group,
  }) : super(key: key);

  final Group group;

  Future<void> _fetchMore(BuildContext context) async {
    context.bloc<PackBloc>().add(RefreshPacks());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(children: <Widget>[
        RefreshIndicator(
          onRefresh: () => _fetchMore(context),
          child: ListView(padding: const EdgeInsets.all(0), children: [
            GroupExpressions(
              key: const PageStorageKey<String>('public-pack'),
              group: group,
              privacy: 'Public',
            ),
          ]),
        ),
        RefreshIndicator(
          onRefresh: () => _fetchMore(context),
          child: ListView(padding: const EdgeInsets.all(0), children: [
            GroupExpressions(
              key: const PageStorageKey<String>('private-pack'),
              group: group,
              privacy: 'Private',
            ),
          ]),
        ),
        RefreshIndicator(
          onRefresh: () => _fetchMore(context),
          child: PackOpenMembers(
            key: UniqueKey(),
            packAddress: group.address,
          ),
        )
      ]),
    );
  }
}
