import 'package:flutter/material.dart';

import 'badge_item.dart';

class MemberBadgesRow extends StatelessWidget {
  const MemberBadgesRow({this.badges});
  final List<dynamic> badges;
  @override
  Widget build(BuildContext context) {
    print(badges);
    print(badges[0]);
    return Container(
      child: Row(
        children: [
          for (String badge in badges) MemberBadgeItem(badge: badge),
        ],
      ),
    );
  }
}
