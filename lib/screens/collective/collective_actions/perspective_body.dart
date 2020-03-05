import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class CreatePerspectiveBody extends StatefulWidget {
  const CreatePerspectiveBody({
    Key key,
    @required this.future,
    @required this.addUser,
    @required this.removeUser,
  }) : super(key: key);
  final Future<Map<String, dynamic>> future;
  final ValueChanged<UserProfile> addUser;
  final ValueChanged<UserProfile> removeUser;

  @override
  _CreatePerspectiveBodyState createState() => _CreatePerspectiveBodyState();
}

class _CreatePerspectiveBodyState extends State<CreatePerspectiveBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: widget.future,
      builder: (
        BuildContext context,
        AsyncSnapshot<Map<String, dynamic>> snapshot,
      ) {
        if (snapshot.hasData) {
          // get list of connections
          final List<UserProfile> _connectionsMembers =
              snapshot.data['connections']['results'];

          // get list of following
          final List<UserProfile> _followingMembers =
              snapshot.data['following']['results'];

          return TabBarView(
            children: <Widget>[
              // subscriptions
              ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    for (UserProfile connection in _followingMembers)
                      MemberPreviewSelect(
                        profile: connection,
                        onSelect: widget.addUser,
                        onDeselect: widget.removeUser,
                      ),
                  ]),
              // connections
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  for (UserProfile connection in _connectionsMembers)
                    MemberPreviewSelect(
                      profile: connection,
                      onSelect: widget.addUser,
                      onDeselect: widget.removeUser,
                    ),
                ],
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return TabBarView(
            children: <Widget>[
              Center(
                child: Transform.translate(
                  offset: const Offset(0.0, -50),
                  child: Text('Hmmm, something is up',
                      style: Theme.of(context).textTheme.caption),
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0.0, -50),
                  child: Text('Hmmm, something is up',
                      style: Theme.of(context).textTheme.caption),
                ),
              ),
            ],
          );
        }
        return TabBarView(
          children: <Widget>[
            Center(
              child: JuntoProgressIndicator(),
            ),
            Center(
              child: JuntoProgressIndicator(),
            ),
          ],
        );
      },
    );
  }
}
