import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/packs.dart';

class JuntoGroupsActions extends StatefulWidget {
  const JuntoGroupsActions({
    @required this.changeGroup,
    this.userProfile,
  });

  final UserData userProfile;
  final Function changeGroup;

  @override
  State<StatefulWidget> createState() => JuntoGroupsActionsState();
}

class JuntoGroupsActionsState extends State<JuntoGroupsActions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      color: Theme.of(context).backgroundColor,
      height: MediaQuery.of(context).size.height - 90,
      child: Packs(
        userProfile: widget.userProfile,
        selectedGroup: widget.changeGroup,
      ),
    );
  }
}
