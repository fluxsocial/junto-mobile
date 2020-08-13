import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:provider/provider.dart';

class Connections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> getUserRelations() async {
      final dynamic userRelations =
          await Provider.of<UserRepo>(context, listen: false).userRelations();

      return userRelations;
    }

    return FutureBuilder<dynamic>(
      future: getUserRelations(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // get list of connections
          final List<UserProfile> _connectionsMembers =
              snapshot.data['connections']['results'];

          if (_connectionsMembers.length > 0) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: _connectionsMembers
                  .map(
                    (dynamic connection) => MemberPreview(profile: connection),
                  )
                  .toList(),
            );
          } else {
            return FeedPlaceholder(
              placeholderText: 'No connections yet!',
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
