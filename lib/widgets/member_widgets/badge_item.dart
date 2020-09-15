import 'package:flutter/material.dart';

class MemberBadgeItem extends StatelessWidget {
  const MemberBadgeItem({this.badge});

  final Widget badge;

  _buildBadge(BuildContext context) {
    Widget badgeIcon;
    if (badge == 'crowdfunder') {
      badgeIcon =
          Icon(Icons.beenhere, size: 17, color: Theme.of(context).primaryColor);
    } else {
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
