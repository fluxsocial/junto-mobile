import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:provider/provider.dart';

class Connections extends StatefulWidget {
  const Connections();

  @override
  State<StatefulWidget> createState() {
    return ConnectionsState();
  }
}

class ConnectionsState extends State<Connections> {
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
          print('getting connections');

          // get list of connections
          final List<UserProfile> _connectionsMembers =
              snapshot.data['connections']['results'];

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: _connectionsMembers
                .map(
                  (dynamic connection) => MemberPreview(profile: connection),
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
