import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/custom_refresh.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

class PackTabs extends StatelessWidget {
  PackTabs({
    Key key,
    @required this.group,
    @required this.user,
  }) : super(key: key);

  final Group group;
  final Completer<void> refreshCompleter = Completer<void>();
  final UserDataProvider user;

  Future<void> _fetchMore(BuildContext context) async {
    await context.bloc<PackBloc>().add(RefreshPacks());
    return refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        CustomRefresh(
          refresh: () {
            _fetchMore(context);
          },
          child: GroupExpressions(
            key: const PageStorageKey<String>('private-pack'),
            group: group,
            privacy: 'Private',
          ),
        ),
        CustomRefresh(
          refresh: () {
            _fetchMore(context);
          },
          child: GroupExpressions(
            key: const PageStorageKey<String>('public-pack'),
            group: group,
            privacy: 'Public',
          ),
        ),
        if (group.address == user.userProfile.pack.address)
          CustomRefresh(
            refresh: () {
              _fetchMore(context);
            },
            child: PackOpenMembers(
              key: UniqueKey(),
              packAddress: group.address,
            ),
          )
      ],
    );
  }
}
