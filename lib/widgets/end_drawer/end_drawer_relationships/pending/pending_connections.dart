import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/relationship_request.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:provider/provider.dart';

class PendingConnections extends StatefulWidget {
  PendingConnections();

  @override
  State<StatefulWidget> createState() {
    return PendingConnectionsState();
  }
}

class PendingConnectionsState extends State<PendingConnections> {
  Future<dynamic> _userRelations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userRelations = getUserRelationships();
  }

  Future<dynamic> getUserRelationships() async {
    return await Provider.of<UserRepo>(context, listen: false).userRelations();
  }

  void _refreshActions(bool action) {
    setState(() {
      _userRelations = getUserRelationships();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _userRelations,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // get list of connections
          final List<UserProfile> _connectionRequests =
              snapshot.data['pending_connections']['results'];

          if (_connectionRequests.length > 0) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: _connectionRequests
                  .map(
                    (dynamic request) =>
                        RelationshipRequest(request, _refreshActions),
                  )
                  .toList(),
            );
          } else {
            return FeedPlaceholder(
              placeholderText: 'No connection requests yet!',
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
