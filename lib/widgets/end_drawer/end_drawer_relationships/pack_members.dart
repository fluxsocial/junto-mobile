import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:provider/provider.dart';

class PackMembers extends StatefulWidget {
  const PackMembers({this.userAddress});

  final String userAddress;

  @override
  State<StatefulWidget> createState() {
    return PackMembersState();
  }
}

class PackMembersState extends State<PackMembers> {
  //TODO(Nash): Replace with bloc
  Future<List<Users>> getPackMembers() async {
    final userData = await Provider.of<UserRepo>(context, listen: false)
        .getUser(widget.userAddress);
    final query = await Provider.of<GroupRepo>(context, listen: false)
        .getGroupMembers(userData.pack.address,
            ExpressionQueryParams(paginationPosition: '0'));
    return query.results;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Users>>(
      future: getPackMembers(),
      builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
        if (snapshot.hasData) {
          final List<Users> packMembers = snapshot.data;

          if (packMembers.length > 0) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: packMembers
                  .map(
                    (dynamic packMember) =>
                        MemberPreview(profile: packMember.user),
                  )
                  .toList(),
            );
          } else {
            return FeedPlaceholder(
              placeholderText: 'No pack members yet!',
              image: 'assets/images/junto-mobile__bench.png',
            );
          }
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return JuntoErrorWidget(errorMessage: 'Hmm, something went wrong');
        }
        return Center(
          child: JuntoProgressIndicator(),
        );
      },
    );
  }
}
