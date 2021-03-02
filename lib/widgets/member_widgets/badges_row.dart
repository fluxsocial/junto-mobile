import 'package:flutter/material.dart';

import 'badge_item.dart';

class MemberBadgesRow extends StatelessWidget {
  const MemberBadgesRow({this.badges});
  final List<dynamic> badges;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.4,
      ),
      child: Wrap(
        runSpacing: 8.0,
        children: [
          for (String badge in badges) MemberBadgeItem(badge: badge),
        ],
      ),
    );
  }
}
