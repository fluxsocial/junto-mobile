import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:provider/provider.dart';

class Subscribers extends StatefulWidget {
  const Subscribers();

  @override
  State<StatefulWidget> createState() {
    return SubscribersState();
  }
}

class SubscribersState extends State<Subscribers> {
  Future<dynamic> getUserRelations() async {
    final dynamic userRelations =
        await Provider.of<UserRepo>(context, listen: false).userRelations();

    return userRelations;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getUserRelations(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print('getting followers');
          final List<UserProfile> _followerMembers =
              snapshot.data['followers']['results'];

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: _followerMembers
                .map(
                  (dynamic subscriber) => MemberPreview(profile: subscriber),
                )
                .toList(),
          );
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
