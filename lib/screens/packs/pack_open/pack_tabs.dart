import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/custom_refresh.dart';

class PackTabs extends StatelessWidget {
  const PackTabs({
    Key key,
    @required this.group,
  }) : super(key: key);

  final Group group;

  Future<void> _fetchMore(BuildContext context) async {
    await context.bloc<PackBloc>().add(RefreshPacks());
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        CustomRefresh(
          refresh: () => _fetchMore(context),
          child: GroupExpressions(
            key: const PageStorageKey<String>('public-pack'),
            group: group,
            privacy: 'Public',
          ),
        ),
        CustomRefresh(
          refresh: () => _fetchMore(context),
          child: GroupExpressions(
            key: const PageStorageKey<String>('private-pack'),
            group: group,
            privacy: 'Private',
          ),
        ),
        CustomRefresh(
          refresh: () => _fetchMore(context),
          child: PackOpenMembers(
            key: UniqueKey(),
            packAddress: group.address,
          ),
        )
      ],
    );
  }
}
