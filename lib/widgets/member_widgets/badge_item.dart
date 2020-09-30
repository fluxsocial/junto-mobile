import 'package:flutter/material.dart';

class MemberBadgeItem extends StatelessWidget {
  const MemberBadgeItem({this.badge});

  final String badge;

  _buildBadge(BuildContext context) {
    Widget badgeIcon;
    if (badge == 'Crowdfunder') {
      badgeIcon =
          Icon(Icons.beenhere, size: 17, color: Theme.of(context).primaryColor);
    } else {
      badgeIcon =
          Icon(Icons.beenhere, size: 17, color: Theme.of(context).primaryColor);
    }
    return badgeIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBadge(context),
    );
  }
}
